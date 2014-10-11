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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.counterView];
    
    // show HUD only on first loading, not when pull-to-refresh triggered

    [self loadSalesFromParse];
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
    
    cell.name = item.name;
    cell.date = sale.createdAt;
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
    if (self.isShowingSold) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CCSale *sale = [CCSales sharedSales].sales[indexPath.row];
        sale.returned = YES;
        
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [self.hud show:YES];
        self.hud.labelText = @"Deleting..";
        
        [sale saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [self refreshCounter];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Parse methods

- (void)loadSalesFromParse {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading..";
    
    PFQuery *query = [CCSale query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"event" equalTo:[[CCEvents sharedEvents] currentEvent]];
    
    [CCSales sharedSales].sales = [NSMutableArray array];
    [CCSales sharedSales].returned = [NSMutableArray array];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSMutableArray *sales = [NSMutableArray array];
            for (CCSale *object in objects) {
                if ([object.createdAt isCurrentDay]) {
                    [sales addObject:object];
                }
            }
            [CCSales sharedSales].sales = sales;
            
            // update UI
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

@end