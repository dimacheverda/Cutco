//
//  CCEventsViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEventsViewController.h"
#import "CCEventsTableView.h"
#import "CCEventTableViewCell.h"

@interface CCEventsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CCEventsTableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation CCEventsViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segmentedControl];
}

#pragma mark - Accessors

- (CCEventsTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CCEventsTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CCEventTableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Closed", @"Current", @"Future"]];
        _segmentedControl.frame = CGRectMake(20.0,
                                             28.0,
                                             CGRectGetWidth(self.view.frame) - 40.0,
                                             28.0);
        _segmentedControl.selectedSegmentIndex = 1;
    }
    return _segmentedControl;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.locationTitleLabel.text = @"Costco store, Baltimore";
    cell.startAtLabel.text = @"10-15-2014";
    cell.endAtLabel.text = @"10-25-2014";
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
