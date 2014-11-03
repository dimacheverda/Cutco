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
#import <AVFoundation/AVFoundation.h>
#import "UIFont+CCFont.h"

@interface CCIntroViewController ()

@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) AVPlayer *player;
@property (nonatomic) BOOL videoFinishedAtLeastOnce;

@end

@implementation CCIntroViewController

#pragma mark - View Controller LifeCycle

#define kOnboardingBackButtonDidPressedNotification @"OnboardingBackButtonDidPressedNotification"
#define kOnboardingNextButtonDidPressedNotification @"OnboardingNextButtonDidPressedNotification"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.moviePlayerController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onboardingBackButtonDidPressed) name:kOnboardingBackButtonDidPressedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onboardingNextButtonDidPressed) name:kOnboardingNextButtonDidPressedNotification object:nil];
    
    [self.player play];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _descriptionLabel.frame = CGRectMake(10.0,
                                         64.0,
                                         CGRectGetWidth(self.view.frame) - 10.0 * 2,
                                         70.0);
    
    _moviePlayerController.view.frame = CGRectMake(0.0,
                                                   CGRectGetMaxY(_descriptionLabel.frame),
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Accessors 

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = @"Indroduction Video";
    }
    return _descriptionLabel;
}

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        
        NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mov"]];
//        NSURL *streamUrl = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/100095175/horses.mov"];
//        NSURL *streamUrl = [NSURL URLWithString:@"https://s3-eu-west-1.amazonaws.com/helpified-development/cutco-video"];
        
        _moviePlayerController =  [[MPMoviePlayerController alloc] initWithContentURL:localUrl];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerDidEnterFullscreenNotification
                                                   object:self.moviePlayerController];
        
        _moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
        _moviePlayerController.shouldAutoplay = NO;
        [_moviePlayerController prepareToPlay];
    }
    return _moviePlayerController;
}

- (AVPlayer *)player {
    if (!_player) {
        NSURL *streamUrl = [NSURL URLWithString:@"http://ds1.downloadtech.net/cn1086/audio/209210320528066-002.mp3"];
        _player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithURL:streamUrl]];
//        _player 
    }
    return _player;
}

#pragma mark - Movie Player

- (void)moviePlayerDidEnterFullscreen:(NSNotification *)notification {
    MPMoviePlayerController *player = [notification object];
    [player play];
}

- (void)moviePlaybackDidFinish:(NSNotification*)notification {
    
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

#pragma mark - Onboarding Navigation Notification MEthods

- (void)onboardingNextButtonDidPressed {
    [self.moviePlayerController pause];
}

- (void)onboardingBackButtonDidPressed {
    [self.moviePlayerController pause];
}

@end
