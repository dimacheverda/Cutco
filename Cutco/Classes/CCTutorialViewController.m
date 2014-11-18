//
//  CCTutorialViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 10/23/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCTutorialViewController.h"
#import "CCAudioPlayerViewController.h"
#import "CCVideoPlayerViewController.h"

@interface CCTutorialViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *videoTitles;
@property (strong, nonatomic) NSArray *videoLinks;
@property (strong, nonatomic) NSArray *audioTitles;
@property (strong, nonatomic) NSArray *audioLinks;

@end

@implementation CCTutorialViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.videoTitles = @[@"Customer Engagement & Value Building",
                         @"Closing New Customers",
                         @"Closing Past Customers",
                         @"Upselling"];
    
    self.videoLinks = @[@"shnr3yIUZdM",
                        @"ThEC9Pa40sc",
                        @"K8PJQdT65XA",
                        @"HVXVPjMt5i0"];
    
    self.audioTitles = @[@"Getting Started as a Demonstrator",
                         @"CJ Mackey - Preparing to Set Up a CUTCO Display at COSTCO",
                         @"CJ Mackey - Preparing to Tear Down a CUTCO Display at COSTCO"];
    
    self.audioLinks = @[@"http://ds1.downloadtech.net/cn1086/audio/209210320528066-002.mp3",
                        @"http://ds1.downloadtech.net/cn1086/audio/129810341132920-001.mp3",
                        @"http://ds1.downloadtech.net/cn1086/audio/573810450532029-002.mp3"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.frame;
    _tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
}

#pragma mark - Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Watch";
    } else if (section == 1){
        return @"Listen";
    } else {
        return @"Read";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.videoTitles.count;
    } else if (section == 1) {
        return self.audioTitles.count;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self setupCellContent:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)setupCellContent:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            
        case 0: {
            cell.textLabel.text = self.videoTitles[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"video"];
        }
            break;
            
        case 1: {
            cell.textLabel.text = self.audioTitles[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"music"];
        }
            break;
            
        case 2: {
            cell.textLabel.text = @"tutorial name";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table View Delefate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case 0: {
            CCVideoPlayerViewController *videoPlayerVC = [[CCVideoPlayerViewController alloc] init];
            videoPlayerVC.videoId = self.videoLinks[indexPath.row];
            [self.navigationController pushViewController:videoPlayerVC animated:YES];
        }
            break;
            
        case 1: {
            NSURL *url = [NSURL URLWithString:self.audioLinks[indexPath.row]];
            NSString *titleText = self.audioTitles[indexPath.row];
            CCAudioPlayerViewController *audioPlayerVC = [[CCAudioPlayerViewController alloc] initWithStreamUrl:url titleText:titleText];
            [self.navigationController pushViewController:audioPlayerVC animated:YES];
        }
            break;
            
        case 2: {
        }
            break;
            
        default:
            break;
    }
    
}


@end
