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
#import <MBProgressHUD.h>
#import "CCEvents.h"
#import "CCEvent.h"
#import "CCSales.h"
#import "CCEventMember.h"
#import "CCLocation.h"
#import "CCStockViewController.h"
#import "CCHistoryViewController.h"

@interface CCEventsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CCEventsTableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSArray *eventsDataSource;

@end

@implementation CCEventsViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segmentedControl];
    
    [self loadEventsMemberFromParse];
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
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Closed", @"In Progress", @"Upcomming"]];
        _segmentedControl.frame = CGRectMake(20.0,
                                             28.0,
                                             CGRectGetWidth(self.view.frame) - 40.0,
                                             28.0);
        _segmentedControl.selectedSegmentIndex = 1;
        [_segmentedControl addTarget:self
                              action:@selector(segmentedControlDidPressed)
                    forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    CCEvent *event = self.eventsDataSource[indexPath.row];
    for (CCLocation *location in [CCEvents sharedEvents].locations) {
        if ([location.objectId isEqualToString:event.location.objectId]) {
            cell.location = location.title;
            break;
        }
    }
    cell.startAt = event.startAt;
    cell.endAt = event.endAt;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [CCEvents sharedEvents].currentEvent = self.eventsDataSource[indexPath.row];
        [self performTransition];
    }
}

- (void)performTransition {
    CCStockViewController *stockVC = [[CCStockViewController alloc] init];
    CCHistoryViewController *soldVC = [[CCHistoryViewController alloc] init];
    CCHistoryViewController *returnedVC = [[CCHistoryViewController alloc] init];
    UIViewController *tutorialVC = [[UIViewController alloc] init];
    UIViewController *statsVC = [[UIViewController alloc] init];
    
    UINavigationController *stockNavController = [[UINavigationController alloc] initWithRootViewController:stockVC];
    
    stockVC.title = @"Add Sale";
    soldVC.title = @"Sold";
    returnedVC.title = @"Returned";
    tutorialVC.title = @"Tutorial";
    statsVC.title = @"Report";
    
    soldVC.isShowingSold = YES;
    returnedVC.isShowingSold = NO;
    
    stockVC.tabBarItem.image = [UIImage imageNamed:@"plus_line"];
    stockVC.tabBarItem.selectedImage = [UIImage imageNamed:@"plus_fill"];
    soldVC.tabBarItem.image = [UIImage imageNamed:@"cart_full_line"];
    soldVC.tabBarItem.selectedImage = [UIImage imageNamed:@"cart_full_fill"];
    returnedVC.tabBarItem.image = [UIImage imageNamed:@"cart_empty_line"];
    returnedVC.tabBarItem.selectedImage = [UIImage imageNamed:@"cart_empty_fill"];
    tutorialVC.tabBarItem.image = [UIImage imageNamed:@"briefcase_line"];
    tutorialVC.tabBarItem.selectedImage = [UIImage imageNamed:@"briefcase_fill"];
    statsVC.tabBarItem.image = [UIImage imageNamed:@"calculator_line"];
    statsVC.tabBarItem.selectedImage = [UIImage imageNamed:@"calculator_fill"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[tutorialVC, returnedVC, stockNavController, soldVC, statsVC];
    [tabBarController setSelectedViewController:stockNavController];
    
    [self presentViewController:tabBarController animated:YES completion:^{
    }];
}

#pragma mark - Parse methods

- (void)loadEventsMemberFromParse {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Loading..";
    
    PFQuery *eventMemberQuary = [CCEventMember query];
    [eventMemberQuary whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [eventMemberQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [CCEvents sharedEvents].eventsMember = objects;
                [self loadEventsFromParse];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.description;
                [self.hud hide:YES afterDelay:2.0];
            });
        }
    }];
}

- (void)loadEventsFromParse {
    NSArray *eventsMember = [CCEvents sharedEvents].eventsMember;
    NSMutableArray *eventsId = [NSMutableArray array];
    
    for (CCEventMember *eventMember in eventsMember) {
        [eventsId addObject:eventMember.event.objectId];
    }
    PFQuery *query = [CCEvent query];
    [query whereKey:@"objectId" containedIn:eventsId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [CCEvents sharedEvents].allEvents = objects;
                [self loadLocationsFromParse];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.description;
                [self.hud hide:YES afterDelay:2.0];
            });
        }
    }];
}

- (void)loadLocationsFromParse {
    NSArray *events = [CCEvents sharedEvents].allEvents;
    NSMutableArray *locationsId = [NSMutableArray array];
    for (CCEvent *event in events) {
        [locationsId addObject:event.location.objectId];
    }
    PFQuery *query = [CCLocation query];
    [query whereKey:@"objectId" containedIn:locationsId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [CCEvents sharedEvents].locations = objects;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.eventsDataSource = [NSArray arrayWithArray:[CCEvents sharedEvents].inProgressEvents];
                    [self.tableView reloadData];
                    
                    [self.hud hide:YES];
                });
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.description;
                [self.hud hide:YES afterDelay:2.0];
            });
        }
    }];
}

#pragma mark - Action handlers

- (void)segmentedControlDidPressed {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.eventsDataSource = [CCEvents sharedEvents].closedEvents;
            break;
        case 1:
            self.eventsDataSource = [CCEvents sharedEvents].inProgressEvents;
            break;
        case 2:
            self.eventsDataSource = [CCEvents sharedEvents].upcommingEvents;
            break;
        default:
            break;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end
