//
//  CCAudioPlayerView.h
//  Cutco
//
//  Created by Dima Cheverda on 11/5/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAudioPlayerView : UIView

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UILabel *fullTimeLabel;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UISlider *scrubber;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end
