//
//  CCReportViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 10/23/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCReportViewController.h"
#import "CCReport.h"

@interface CCReportViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CCReport *report;
@property (strong, nonatomic) NSArray *totalTitles;
@property (strong, nonatomic) NSArray *todayTitles;
@property (strong, nonatomic) NSArray *totalValues;
@property (strong, nonatomic) NSArray *todayValues;

@end

@implementation CCReportViewController

#pragma mark - View Controller LifeCycle

#define kReportUpdatedNotificationName @"kReportUpdatedNotificationName"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.report = [[CCReport alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView)
                                                 name:kReportUpdatedNotificationName
                                               object:nil];
    
    self.totalTitles = [NSArray arrayWithObjects:
                        @"Sold",
                        @"Returned",
                        @"Revenue",
                        @"Be Backs",
                        @"Came Backs",
                        @"Came Back Percetage",
                        @"New Customers",
                        nil
                        ];
    
    self.todayTitles = [NSArray arrayWithObjects:
                        @"Sold",
                        @"Returned",
                        @"Revenue",
                        @"Be Backs",
                        @"Came Backs",
                        @"Came Back Percentage",
                        @"New Customers",
                        nil
                        ];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.report updateReportData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
}

- (void)updateReportValues {
    self.totalValues = @[self.report.totalSalesNumber,
                         self.report.totalReturnedNumber,
                         self.report.totalSalesRevenue,
                         self.report.totalBeBacks,
                         self.report.totalCameBacks,
                         self.report.totalCameBackPercentage,
                         self.report.totalNewCustomers];
    
    self.todayValues = @[self.report.todaySalesNumber,
                         self.report.todayReturnedNumber,
                         self.report.todaySalesRevenue,
                         self.report.todayBeBacks,
                         self.report.todayCameBacks,
                         self.report.todayCameBackPercentage,
                         self.report.todayNewCustomers];
}

#pragma mark - Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.totalTitles.count;
    } else {
        return self.todayTitles.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *headerTitle = @[@"Total", @"Today"];
    return headerTitle[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    [self setupCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)setupCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {

    NSArray *titles = [NSArray array];
    NSArray *values = [NSArray array];
    if (indexPath.section == 0) {
        titles = self.totalTitles;
        values = self.totalValues;
    } else {
        titles = self.todayTitles;
        values = self.todayValues;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", titles[indexPath.row]];
    
    switch (indexPath.row) {
        case 0: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ items", values[indexPath.row]];
        }
            break;
        
        case 1: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ items", values[indexPath.row]];
        }
            break;
        
        case 2: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [values[indexPath.row] doubleValue]];
        }
            break;
        
        case 3: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ customers", values[indexPath.row]];
        }
            break;
        
        case 4: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ customers", values[indexPath.row]];
        }
            break;
            
        case 5: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%%", [values[indexPath.row] doubleValue]];
        }
            break;
            
        case 6: {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ customers", values[indexPath.row]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Notification Methods

- (void)updateTableView {
    [self updateReportValues];
    
    [self.tableView reloadData];
}

@end
