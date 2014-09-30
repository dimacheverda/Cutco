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

@interface CCHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CCHistoryTableView *tableView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation CCHistoryViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Sold", @"Returned"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlDidPressed)
                    forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    [self.view addSubview:self.tableView];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading..";
    [self loadSalesFromParse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
}

#pragma mark - Accessors

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
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return [CCSales sharedSales].sales.count;
    } else {
        return [CCSales sharedSales].returned.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CCHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CCSale *sale;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
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
    if (self.segmentedControl.selectedSegmentIndex == 0) {
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
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                });
                [[CCSales sharedSales] moveSaleToReturnedAtIndex:indexPath.row];
                
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Success";
                [self.hud hide:YES afterDelay:1.0];
            } else {
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.localizedDescription;
                [self.hud hide:YES afterDelay:2.0];
            }
        }];
    }
}

- (void)loadSalesFromParse {
    PFQuery *query = [CCSale query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // parse PFObject to CCSale's
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
            });
        } else {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Error";
            self.hud.detailsLabelText = error.localizedDescription;
            [self.hud hide:YES afterDelay:1.5f];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.refreshControl endRefreshing];
        });
    }];
}

#pragma mark - Action Handlers

- (void)segmentedControlDidPressed {
    [self.tableView reloadData];
}

@end