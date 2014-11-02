//
//  CCIntroViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 11/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCIntroViewController.h"
#import "CCPaperWorkViewController.h"
#import "CCOnboardingViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CCIntroViewController ()

@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (nonatomic) BOOL videoFinishedAtLeastOnce;

@end

@implementation CCIntroViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.descriptionLabel];
    self.descriptionLabel.text = @"Intro VC";
    
    
    [self.view addSubview:self.moviePlayerController.view];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _descriptionLabel.frame = CGRectMake(10.0, 100.0, 300.0, 40.0);
    
    _moviePlayerController.view.frame = CGRectMake(0.0,
                                                   74.0,
                                                   CGRectGetWidth(self.view.frame),
                                                   CGRectGetWidth(self.view.frame) / 4.0 * 3.0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupForOnboarding];
}

#pragma mark - Accessors 

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
    }
    return _descriptionLabel;
}

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        
        
        NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mov"]];
//        NSURL *streamUrl = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/100095175/horses.mov"];
        
        _moviePlayerController =  [[MPMoviePlayerController alloc] initWithContentURL:localUrl];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayerController];
        
        _moviePlayerController.controlStyle = MPMovieControlStyleDefault;
        _moviePlayerController.shouldAutoplay = NO;
        [_moviePlayerController prepareToPlay];
    }
    return _moviePlayerController;
}

#pragma mark - Movie Player

- (void)moviePlaybackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    NSNumber *finishResult = notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([finishResult integerValue] == MPMovieFinishReasonPlaybackEnded) {
        self.videoFinishedAtLeastOnce = YES;
        [self setupForOnboarding];
    }
}

#pragma mark - Onboarding Methods

- (void)setupForOnboarding {
    if ([self.parentViewController isKindOfClass:[CCOnboardingViewController class]]) {
        self.parentViewController.navigationItem.leftBarButtonItem.enabled = NO;
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = self.videoFinishedAtLeastOnce;
    }
}

@end
