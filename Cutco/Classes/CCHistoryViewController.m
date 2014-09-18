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

@interface CCHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CCHistoryViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Sold", @"Returned"]];
    segmentedControl.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = segmentedControl;
    
    [self.view addSubview:self.tableView];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadSalesFromParse];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
}

#pragma mark - Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0f;
        [_tableView registerClass:[CCHistoryTableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sales.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CCHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    CCSale *sale = self.sales[indexPath.row];
    
    cell.name = sale.stockItem.objectId;
    cell.image = [UIImage imageNamed:@"cart"];
    cell.date = sale.createdAt;
    
    return cell;
}

- (void)loadSalesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Sale"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *sales = [NSMutableArray array];
            for (PFObject *object in objects) {
                CCSale *sale = [[CCSale alloc] initWithPFObject:object];
                [sales addObject:sale];
            }
            self.sales = sales;
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
    }];
}

@end