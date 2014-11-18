//
//  CCVideoPlayerViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 11/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCVideoPlayerViewController.h"
#import <youtube-ios-player-helper/YTPlayerView.h>

@interface CCVideoPlayerViewController () <YTPlayerViewDelegate>

@property (strong, nonatomic) YTPlayerView *playerView;

@end

@implementation CCVideoPlayerViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.playerView];
    NSDictionary *playerVars = @{
                                 @"autoplay" : @1,
                                 @"autohide" : @1
                                 };

    [self.playerView loadWithVideoId:self.videoId playerVars:playerVars];
    [self.playerView playVideo];
    self.playerView.webView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.playerView.frame = CGRectMake(0.0,
                                       84.0,
                                       CGRectGetWidth(self.view.frame),
                                       CGRectGetWidth(self.view.frame));
}

#pragma mark - Accessors

- (YTPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[YTPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor clearColor];
    }
    return _playerView;
}

@end
