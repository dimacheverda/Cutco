//
//  CCPaperWorkViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 11/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCPaperWorkViewController.h"
#import "CCOnboardingViewController.h"
#import "CCCheckBox.h"
#import "UIFont+CCFont.h"

@interface CCPaperWorkViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) CCCheckBox *checkBox;

@end

@implementation CCPaperWorkViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.checkBox];
    
    self.titleLabel.text = @"Complete employee paper work";
    
    NSString *desciptionString = @"By pressing checkbox below you confirming that you has completed employee paper work";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:desciptionString];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:8];
    paragrahStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [desciptionString length])];
    self.descriptionLabel.attributedText = attrStr;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _titleLabel.frame = CGRectMake(16.0,
                                   64.0 + 16.0,
                                   CGRectGetWidth(self.view.frame) - 16.0 * 2,
                                   40.0);
    
    _descriptionLabel.frame = CGRectMake(16.0,
                                         CGRectGetMaxY(self.titleLabel.frame),
                                         CGRectGetWidth(self.view.frame) - 16.0 * 2,
                                         100.0);
    
    _checkBox.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    _checkBox.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.descriptionLabel.frame) + 40.0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupForOnboarding];
}

#pragma mark - Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.font = [UIFont primaryCopyTypefaceWithSize:17.0];
    }
    return _descriptionLabel;
}

- (CCCheckBox *)checkBox {
    if (!_checkBox) {
        _checkBox = [[CCCheckBox alloc] init];
        _checkBox.checked = NO;
        _checkBox.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCheckboxTap)];
        [_checkBox addGestureRecognizer:tap];
    }
    return _checkBox;
}

#pragma mark - Gesture Recognizer

- (void)handleCheckboxTap {
    self.checkBox.checked = !self.checkBox.isChecked;
    
    [self setupForOnboarding];
}

#pragma mark - Onboarding Methods

- (void)setupForOnboarding {
    if ([self.parentViewController isKindOfClass:[CCOnboardingViewController class]]) {
        self.parentViewController.navigationItem.leftBarButtonItem.enabled = YES;
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = self.checkBox.isChecked;
    }
}

@end
