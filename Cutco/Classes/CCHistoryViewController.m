//
//  CCHistoryViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCHistoryViewController.h"
#import "CCHistoryTableViewCell.h"
#import <Parse/Parse.h>
#import "CCSale.h"
#import <MBProgressHUD.h>
#import "CCHistoryTableView.h"
#import "CCStock.h"
#import "CCSales.h"
#import "NSDate+CCDate.h"
#import "CCCounterView.h"

@interface CCHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CCCounterView *counterView;
@property (strong, nonatomic) CCHistoryTableView *tableView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CCHistoryViewController

#pragma mark - View Controller LifeCycle

#define kSeparatorInset UIEdgeInsetsMake(0.0, 135.0, 0.0, 0.0)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.counterView];
    
    // show HUD only on first loading, not when pull-to-refresh triggered
    
    // add notification observer only for returned VC
    if (!self.isShowingSold) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateNotificationDidRecieved)
                                                     name:@"kSalesUpdatedNotificationName"
                                                   object:nil];
    }
    
    if (![CCSales sharedSales].isLoaded) {
        [self loadSalesFromParse];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self refreshCounter];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - Accessors

- (CCCounterView *)counterView {
    if (!_counterView) {
        NSString *placeholder = [NSString string];
        if (self.isShowingSold) {
            placeholder = @"Items sold:";
        } else {
            placeholder = @"Items returned:";
        }
        _counterView = [[CCCounterView alloc] initWithPlaceholder:placeholder];
        _counterView.frame = CGRectMake(0.0,
                                        0.0,
                                        CGRectGetWidth(self.view.frame),
                                        64.0);
        if (self.isShowingSold) {
            _counterView.count = [CCSales sharedSales].sales.count;
        } else {
            _counterView.count = [CCSales sharedSales].returned.count;
        }
    }
    return _counterView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[CCHistoryTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CCHistoryTableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView.refreshControl addTarget:self
                                      action:@selector(loadSalesFromParse)
                            forControlEvents:UIControlEventValueChanged];
    }
    return _tableView;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isShowingSold) {
        return [CCSales sharedSales].sales.count;
    } else {
        return [CCSales sharedSales].returned.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:kSeparatorInset];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:kSeparatorInset];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CCHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CCSale *sale;
    
    if (self.isShowingSold) {
        sale = [CCSales sharedSales].sales[indexPath.row];
    } else {
        sale = [CCSales sharedSales].returned[indexPath.row];
    }
    CCStockItem *item = [[CCStock sharedStock] itemForObjectId:sale.stockItem.objectId];
    
    cell.index = self.counterView.count - indexPath.row;
    cell.name = item.name;
    
    (self.isShowingSold) ? (cell.date = sale.createdAt) : (cell.date = sale.updatedAt);
    
//    if (self.isShowingSold) {
//        cell.date = sale.createdAt;
//    } else {
//        cell.date = sale.updatedAt;
//    }
    
    [item.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image = image;
            });
        }
    }];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isShowingSold;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CCSale *sale = [CCSales sharedSales].sales[indexPath.row];
        sale.returned = YES;
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [self.hud show:YES];
        self.hud.labelText = @"Returning..";
        
        [sale saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [self refreshCounter];
                    [self updateCellIndexLabels];
                });
                [[CCSales sharedSales] moveSaleToReturnedAtIndex:indexPath.row];
                [self.hud hide:YES afterDelay:0.0];
            } else {
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.localizedDescription;
                [self.hud hide:YES afterDelay:2.0];
            }
        }];
    }
}

#pragma mark - Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Return";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Parse methods

- (void)loadSalesFromParse {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading..";
    
    [[CCSales sharedSales] loadSalesFromParseWithCompletion:^(NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [self.tableView reloadData];
                [self refreshCounter];
            });
            
        } else {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Error";
            self.hud.detailsLabelText = error.localizedDescription;
            [self.hud hide:YES afterDelay:1.5f];
        }
        
        // hide refresh control if shown
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView.refreshControl.isRefreshing) {
                [self.tableView.refreshControl endRefreshing];
            }
        });
    }];
}

#pragma mark - Counter Refresh method

- (void)refreshCounter {
    if (self.isShowingSold) {
        self.counterView.count = [CCSales sharedSales].sales.count;
    } else {
        self.counterView.count = [CCSales sharedSales].returned.count;
    }
}

- (void)updateCellIndexLabels {
    NSInteger cellsCount = self.counterView.count;
    for (NSInteger i = 0; i < cellsCount; i++) {
        CCHistoryTableViewCell *cell = (CCHistoryTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.index = cellsCount - i;
    }
}

- (void)updateNotificationDidRecieved {
    [self refreshCounter];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end