//
//  CCGuidelinesViewControlller.m
//  Cutco
//
//  Created by Dima Cheverda on 11/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCGuidelinesViewControlller.h"
#import "CCOnboardingViewController.h"

@interface CCGuidelinesViewControlller ()

@property (strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation CCGuidelinesViewControlller

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.descriptionLabel];
    self.descriptionLabel.text = @"Guidelines VC";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _descriptionLabel.frame = CGRectMake(10.0, 100.0, 300.0, 40.0);
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

#pragma mark - Onboarding Methods

- (void)setupForOnboarding {
    if ([self.parentViewController isKindOfClass:[CCOnboardingViewController class]]) {
        self.parentViewController.navigationItem.leftBarButtonItem.enabled = YES;
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

@end