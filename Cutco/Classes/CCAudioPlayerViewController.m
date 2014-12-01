//
//  CCAudioPlayerViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 11/5/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCAudioPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CCAudioPlayerView.h"
#import "CCOnboardingViewController.h"

@interface CCAudioPlayerViewController ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) CCAudioPlayerView *audioPlayerView;
@property (strong, nonatomic) id timeObserver;
@property (nonatomic) float afterScrubbingRate;
@property (nonatomic) BOOL audioFinishedAtLeastOnce;
@property (nonatomic) BOOL seekToZeroBeforePlay;

@end

static void *AVPlayerPlaybackStatusObservationContext = &AVPlayerPlaybackStatusObservationContext;

@implementation CCAudioPlayerViewController

#pragma mark - Init

- (instancetype)initWithStreamUrl:(NSURL *)streamUrl titleText:(NSString *)titleText {
    self = [super init];
    if (self) {
        _streamUrl = streamUrl;
        [self.view addSubview:self.audioPlayerView];
        self.audioPlayerView.titleLabel.text = titleText;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleText];
        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setLineSpacing:15];
        paragrahStyle.alignment = NSTextAlignmentCenter;
        [attrStr addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [titleText length])];
        self.audioPlayerView.titleLabel.attributedText = attrStr;
    }
    return self;
}

#pragma mark - View Controlller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initScrubberTimer];
    [self syncTimeLabel];
    [self syncPlayPauseButton];
    [self syncScrubber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupForOnboarding];
    [self syncPlayPauseButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player pause];

    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [self removePlayerTimeObserver];
    [self syncPlayPauseButton];
}

- (void)setupForOnboarding {
    if ([self.parentViewController isKindOfClass:[CCOnboardingViewController class]]) {
        self.parentViewController.navigationItem.leftBarButtonItem.enabled = NO;
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;
//        self.parentViewController.navigationItem.rightBarButtonItem.enabled = self.audioFinishedAtLeastOnce;
    }
}

#pragma mark - Accessors

- (CCAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[CCAudioPlayerView alloc] initWithFrame:self.view.frame];
        
        [_audioPlayerView.playButton addTarget:self
                                             action:@selector(playButtonDidPressed:)
                                   forControlEvents:UIControlEventTouchUpInside];
        
        [_audioPlayerView.pauseButton addTarget:self
                                             action:@selector(pauseButtonDidPressed:)
                                   forControlEvents:UIControlEventTouchUpInside];
        
        [_audioPlayerView.scrubber addTarget:self
                                      action:@selector(scrubberValueDidChange:)
                            forControlEvents:UIControlEventValueChanged];
        [_audioPlayerView.scrubber addTarget:self
                                      action:@selector(scrubberValueDidChange:)
                            forControlEvents:UIControlEventTouchDragInside];
        
        [_audioPlayerView.scrubber addTarget:self
                                      action:@selector(beginScrubbing:)
                            forControlEvents:UIControlEventTouchDown];
        
        [_audioPlayerView.scrubber addTarget:self
                                      action:@selector(endScrubbing:)
                            forControlEvents:UIControlEventTouchCancel];
        [_audioPlayerView.scrubber addTarget:self
                                      action:@selector(endScrubbing:)
                            forControlEvents:UIControlEventTouchUpInside];
        [_audioPlayerView.scrubber addTarget:self
                                      action:@selector(endScrubbing:)
                            forControlEvents:UIControlEventTouchUpOutside];
    }
    return _audioPlayerView;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithURL:self.streamUrl];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidEndPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_player.currentItem];
        [_player addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:AVPlayerPlaybackStatusObservationContext];
    }
    return _player;
}

#pragma mark - Player

- (void)playButtonDidPressed:(UIButton *)sender {
    if (self.seekToZeroBeforePlay) {
        [self.player seekToTime:CMTimeMakeWithSeconds(0, 1)];
        self.seekToZeroBeforePlay = NO;
    }
    
    [self.player play];
    
    // to prevent phone from going to slepp during playback
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self syncPlayPauseButton];
}

- (void)pauseButtonDidPressed:(UIButton *)sender {
    [self.player pause];

    // to prevent phone from going to slepp during playback
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [self syncPlayPauseButton];
}

- (void)playerItemDidEndPlaying:(AVPlayer *)player {
    
    // to prevent phone from going to slepp during playback
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    self.audioFinishedAtLeastOnce = YES;
    self.seekToZeroBeforePlay = YES;
    [self syncPlayPauseButton];
    [self setupForOnboarding];
//    NSLog(@"playerItemDidEndPlaying");
}

- (void)syncPlayPauseButton {
    if (self.player.rate > 0 && !self.player.error) {
        self.audioPlayerView.playButton.hidden = YES;
        self.audioPlayerView.pauseButton.hidden = NO;
    } else if (self.player.rate == 0 && !self.player.error) {
        self.audioPlayerView.playButton.hidden = NO;
        self.audioPlayerView.pauseButton.hidden = YES;
    }
}

#pragma mark - Player Controls

- (void)disableScrubber {
    self.audioPlayerView.scrubber.enabled = NO;
    self.audioPlayerView.fullTimeLabel.enabled = NO;
    self.audioPlayerView.currentTimeLabel.enabled = NO;
}

- (void)disablePlayerButtons {
    self.audioPlayerView.playButton.enabled = NO;
    self.audioPlayerView.pauseButton.enabled = NO;
}

- (void)enableScrubber {
    self.audioPlayerView.scrubber.enabled = YES;
    self.audioPlayerView.fullTimeLabel.enabled = YES;
    self.audioPlayerView.currentTimeLabel.enabled = YES;
}

- (void)enablePlayerButtons {
    self.audioPlayerView.playButton.enabled = YES;
    self.audioPlayerView.pauseButton.enabled = YES;
}

#pragma mark - Player Scrubber

- (void)initScrubberTimer {
    double interval = 1.0f;
    
    CMTime playerDuration = [self playerItemDuration];
//    NSLog(@"init scrubber");


//    if (CMTIME_IS_INVALID(playerDuration)) {
//        return;
//    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    
    if (isfinite(duration)) {
        CGFloat width = CGRectGetWidth([self.audioPlayerView.scrubber bounds]);
        interval = 0.5f * duration / width;
    }
    
    __weak CCAudioPlayerViewController *weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)  queue:NULL usingBlock:^(CMTime time) {
        [weakSelf syncScrubber];
        [weakSelf syncTimeLabel];
//        NSLog(@"sync scrubber");
    }];
}

- (CMTime)playerItemDuration {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        return ([self.player.currentItem duration]);
    }
    return(kCMTimeInvalid);
}

- (void)syncScrubber {
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        self.audioPlayerView.scrubber.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0)) {
        float minValue = self.audioPlayerView.scrubber.minimumValue;
        float maxValue = self.audioPlayerView.scrubber.maximumValue;
        double time = CMTimeGetSeconds(self.player.currentTime);
        [self.audioPlayerView.scrubber setValue:(maxValue - minValue) * time / duration + minValue];
    }
}

- (void)syncTimeLabel {
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        self.audioPlayerView.scrubber.minimumValue = 0.0;
        return;
    }
    
    double fullDuration = CMTimeGetSeconds(playerDuration);
    int minutes = (int)fullDuration / 60;
    int seconds = (int)fullDuration % 60;
    self.audioPlayerView.fullTimeLabel.text = [NSString stringWithFormat:@"%2d:%2d", minutes, seconds];
    
    double currentTime = CMTimeGetSeconds(self.player.currentTime);
    int currentMinutes = (int)currentTime / 60;
    int currentSeconds = (int)currentTime % 60;
    self.audioPlayerView.currentTimeLabel.text = [NSString stringWithFormat:@"%2.2d:%2.2d", currentMinutes, currentSeconds];
}

#pragma mark - Scrubbing Action Methods

- (void)beginScrubbing:(UISlider *)slider {
//    NSLog(@"scrub begin");
    self.afterScrubbingRate = self.player.rate;
    self.player.rate = 0.0;
    self.seekToZeroBeforePlay = NO;
}

- (void)scrubberValueDidChange:(UISlider *)slider {
    
    float minValue = [slider minimumValue];
    float maxValue = [slider maximumValue];
    float value = [slider value];
    
    CMTime playerDuration = [self playerItemDuration];
    
    double duration = CMTimeGetSeconds(playerDuration);
    double time = duration * (value - minValue) / (maxValue - minValue);
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:nil];
}

- (void)endScrubbing:(UISlider *)slider {
//    NSLog(@"scrub end");
    self.player.rate = self.afterScrubbingRate;
    self.afterScrubbingRate = 0.0;
//    NSLog(@"end srubbing rate %f", self.player.rate);
}

#pragma mark - KVO Player status

- (void)observeValueForKeyPath:(NSString*)path ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (context == AVPlayerPlaybackStatusObservationContext) {
        [self syncPlayPauseButton];
        
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown: {
//                NSLog(@"AVPlayerItemStatusUnknown");
                
                [self removePlayerTimeObserver];
                
                [self syncScrubber];
                [self syncTimeLabel];
                
                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay: {
//                NSLog(@"AVPlayerItemStatusReadyToPlay");
                
                [self initScrubberTimer];
                
                [self enableScrubber];
                [self enablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusFailed: {
//                NSLog(@"AVPlayerItemStatusFailed");
            }
                break;
        }
    }
    else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

- (void)removePlayerTimeObserver {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        [self.player removeObserver:self forKeyPath:@"status"];
        self.timeObserver = nil;
//        NSLog(@"remove time observer %@", self.player.observationInfo);
    }
}

@end
