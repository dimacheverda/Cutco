//
//  CCGuidelinesViewControlller.m
//  Cutco
//
//  Created by Dima Cheverda on 11/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCGuidelinesViewControlller.h"
#import "CCOnboardingViewController.h"
#import "CCGuidelinesTextView.h"

@interface CCGuidelinesViewControlller () <UITextViewDelegate>

//@property (strong, nonatomic) UILabel *descriptionLabel;
//@property (strong, nonatomic) UILabel *guidelineLabel;
@property (strong, nonatomic) CCGuidelinesTextView *textView;
@property (nonatomic, getter=isTextViewScrolledToDown) BOOL textViewScrolledToDown;

@end

@implementation CCGuidelinesViewControlller

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _textView.frame = self.view.frame;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupForOnboarding];
}

#pragma mark - Accessors

- (CCGuidelinesTextView *)textView {
    if (!_textView) {
        _textView = [[CCGuidelinesTextView alloc] initWithFrame:self.view.frame];
        _textView.delegate = self;
    }
    return _textView;
}


#pragma mark - Onboarding Methods

- (void)setupForOnboarding {
    if ([self.parentViewController isKindOfClass:[CCOnboardingViewController class]]) {
        self.parentViewController.navigationItem.leftBarButtonItem.enabled = YES;
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = self.isTextViewScrolledToDown;
    }
}

#pragma mark - Text View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        self.textViewScrolledToDown = YES;
        [self setupForOnboarding];
    }
}

@end