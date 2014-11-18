//
//  SignInViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/12/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCSignInViewController.h"
#import "CCStockViewController.h"
#import "CCHistoryViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD.h>
#import "CCEventsViewController.h"
#import "CCTextField.h"
#import "UIColor+CCColor.h"
#import "UIFont+CCFont.h"
#import "CCIntroViewController.h"
#import "CCPaperWorkViewController.h"
#import "CCOnboardingViewController.h"
#import "CCGuidelinesViewControlller.h"
//#import <MediaPlayer/MediaPlayer.h>
#import "CCAudioPlayerViewController.h"

@interface CCSignInViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *logoImage;
@property (strong, nonatomic) CCTextField *emailTextField;
@property (strong, nonatomic) CCTextField *passwordTextField;
@property (strong, nonatomic) UIButton *signInButton;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CCSignInViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIView setAnimationsEnabled:YES];
    
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.signInButton];
    [self.view addSubview:self.separatorView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.emailTextField.text = @"";
    self.passwordTextField.text = @"";
    [self tapGestureHandler];
}

#define LEFT_PADDING 50.0

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    _logoImage.frame = self.view.frame;
    
    _emailTextField.frame = CGRectMake(LEFT_PADDING,
                                       80.0,
                                       CGRectGetWidth(self.view.frame) - LEFT_PADDING*2,
                                       44.0);

    _passwordTextField.frame = CGRectMake(LEFT_PADDING,
                                          CGRectGetMaxY(_emailTextField.frame) + 16.0,
                                          CGRectGetWidth(self.view.frame) - LEFT_PADDING*2,
                                          44.0);

    _signInButton.frame = CGRectMake(LEFT_PADDING,
                                     CGRectGetMaxY(_passwordTextField.frame) + 20.0,
                                     CGRectGetWidth(self.view.frame) - LEFT_PADDING*2,
                                     44.0);
    _separatorView.frame = CGRectMake(CGRectGetMinX(self.emailTextField.frame),
                                      (CGRectGetMaxY(self.emailTextField.frame) + CGRectGetMinY(self.passwordTextField.frame))/2,
                                      CGRectGetWidth(self.emailTextField.frame),
                                      1.0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steak-knife-blur"]];
        _logoImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _logoImage;
}

- (CCTextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[CCTextField alloc] init];
        _emailTextField.delegate = self;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor placeholderTextColor]}];
    }
    return _emailTextField;
}

- (CCTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[CCTextField alloc] init];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor placeholderTextColor]}];
    }
    return _passwordTextField;
}

- (UIButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [_signInButton addTarget:self
                          action:@selector(signInButtonDidPressed)
                forControlEvents:UIControlEventTouchUpInside];
        _signInButton.backgroundColor = [UIColor signInButtonColor];
        [_signInButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        _signInButton.layer.cornerRadius = 4.0;
        _signInButton.titleLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
    }
    return _signInButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [UIColor whiteColor];
    }
    return _separatorView;
}

#pragma mark - Action Handlers

- (void)signInButtonDidPressed {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![self.emailTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        self.hud.labelText = @"Loading";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self performTransition];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.hud.mode = MBProgressHUDModeText;
                    self.hud.labelText = @"Error";
                    self.hud.detailsLabelText = [NSString stringWithFormat:@"%@", error.localizedDescription];
                    [self.hud hide:YES afterDelay:2.0];
                });
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.labelText = @"Error";
            self.hud.detailsLabelText = @"Fill all fields";
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hide:YES afterDelay:1.5];
        });
    }
}

- (void)performTransition {
    // onboarding transtion
    
    NSURL *streamUrl = [NSURL URLWithString:@"http://ds1.downloadtech.net/cn1086/audio/209210320528066-002.mp3"];
    NSString *titleString = @"Welcome to Cutco's demonstrator training for Costco.\nStart the audio track below to begin your training.";
    
    CCAudioPlayerViewController *audioPlayerVC = [[CCAudioPlayerViewController alloc] initWithStreamUrl:streamUrl titleText:titleString];
    CCPaperWorkViewController *paperWorkVC = [[CCPaperWorkViewController alloc] init];
    CCGuidelinesViewControlller *guidelinesVC = [[CCGuidelinesViewControlller alloc] init];
    
    CCOnboardingViewController *onboardingVC = [[CCOnboardingViewController alloc] initWithViewControllers:@[audioPlayerVC, paperWorkVC, guidelinesVC]];
    
    UINavigationController *onboardingNavController = [[UINavigationController alloc] initWithRootViewController:onboardingVC];
    [self presentViewController:onboardingNavController animated:YES completion:nil];
    
    // events transition
//    CCEventsViewController *eventsVC = [[CCEventsViewController alloc] init];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:eventsVC];
//    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tapGestureHandler {
    if ([self.emailTextField isFirstResponder]) {
        [self.emailTextField resignFirstResponder];
    } else if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        if ([self.passwordTextField canBecomeFirstResponder]) {
            [self.passwordTextField becomeFirstResponder];
        }
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
