//
//  CCAudioPlayerView.m
//  Cutco
//
//  Created by Dima Cheverda on 11/5/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCAudioPlayerView.h"
#import "UIFont+CCFont.h"
#import "UIColor+CCColor.h"

@implementation CCAudioPlayerView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.scrubber];
        [self addSubview:self.fullTimeLabel];
        [self addSubview:self.currentTimeLabel];
//        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#define kButtonHeight 44.0
#define kButtonWidth 44.0

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _playButton.frame = CGRectMake(CGRectGetMidX(self.frame),
                                   CGRectGetHeight(self.frame) - kButtonHeight - 20.0 - 49.0,
                                   kButtonWidth,
                                   kButtonHeight);
    _playButton.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(_playButton.frame));
    
    _pauseButton.frame = _playButton.frame;
    
    CGFloat sliderInset = 40.0;
    _scrubber.frame = CGRectMake(sliderInset,
                                 CGRectGetMinY(_playButton.frame) - 40.0,
                                 CGRectGetWidth(self.frame) - 2 * sliderInset,
                                 20.0);
    
    _currentTimeLabel.frame = CGRectMake(0.0,
                                         CGRectGetMinY(_scrubber.frame),
                                         sliderInset,
                                         20.0);
    
    _fullTimeLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - sliderInset,
                                      CGRectGetMinY(_scrubber.frame),
                                      sliderInset,
                                      20.0);
    
    _titleLabel.frame = CGRectMake(16.0,
                                   64.0 + 16.0,
                                   CGRectGetWidth(self.frame) - 16.0 * 2,
                                   200.0);
    
    _imageView.frame = self.frame;
    
}

#pragma mark - Accessors

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        _playButton.tintColor = [UIColor eventTypeSegmentedControlTintColor];
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_pauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        _pauseButton.tintColor = [UIColor eventTypeSegmentedControlTintColor];
    }
    return _pauseButton;
}

- (UISlider *)scrubber {
    if (!_scrubber) {
        _scrubber = [[UISlider alloc] init];
        _scrubber.tintColor = [UIColor eventTypeSegmentedControlTintColor];
        [_scrubber setThumbImage:[UIImage imageNamed:@"scrubber_thumb_brown_small"] forState:UIControlStateNormal];
        _scrubber.tintColor = [UIColor lightGrayColor];
    }
    return _scrubber;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont primaryCopyTypefaceWithSize:11.0];
        _currentTimeLabel.numberOfLines = 1;
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UILabel *)fullTimeLabel {
    if (!_fullTimeLabel) {
        _fullTimeLabel = [[UILabel alloc] init];
        _fullTimeLabel.font = [UIFont primaryCopyTypefaceWithSize:11.0];
        _fullTimeLabel.numberOfLines = 1;
        _fullTimeLabel.text = @"00:00";
        _fullTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fullTimeLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coming-soon"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
    }
    return _titleLabel;
}

@end
