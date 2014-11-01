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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.report updateReportData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
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
    NSArray *sections = @[@3, @3];
    return [sections[section] integerValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *headerTitle = @[@"Overview", @"Today"];
    return headerTitle[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    [self setupCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)setupCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    NSArray *overviewTitle = @[@"Total Sold", @"Total Returned", @"Total Revenue"];
    NSArray *overviewValues = @[self.report.totalSalesNumber, self.report.totalReturnedNumber, self.report.totalSalesRevenue];
    
    NSArray *todayTitle = @[@"Sold", @"Returned", @"Revenue"];
    NSArray *todayValues = @[self.report.todaySalesNumber, self.report.todayReturnedNumber, self.report.todaySalesRevenue];
    
    switch (indexPath.section) {
        case 0: {
            NSString *valueString = @"";
            
            if (indexPath.row == 2) {
                valueString = [NSString stringWithFormat:@"$%@", overviewValues[indexPath.row]];
            } else {
                valueString = [NSString stringWithFormat:@"%@ items", overviewValues[indexPath.row]];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", overviewTitle[indexPath.row]];
            cell.detailTextLabel.text = valueString;
            
            break;
        }
        case 1: {
            NSString *valueString = @"";
            
            if (indexPath.row == 2) {
                valueString = [NSString stringWithFormat:@"$%@", todayValues[indexPath.row]];
            } else {
                valueString = [NSString stringWithFormat:@"%@ items", todayValues[indexPath.row]];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", todayTitle[indexPath.row]];
            cell.detailTextLabel.text = valueString;
            break;
        }
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
    [self.tableView reloadData];
}

@end
