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
#import <ProgressHUD.h>
#import <MBProgressHUD.h>
#import "CCEventsViewController.h"
#import "CCTextField.h"

@interface CCSignInViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *logoImage;
@property (strong, nonatomic) CCTextField *emailTextField;
@property (strong, nonatomic) CCTextField *passwordTextField;
@property (strong, nonatomic) UIButton *signInButton;
@property (strong, nonatomic) UIView *separatorView;

@end

@implementation CCSignInViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.signInButton];
    [self.view addSubview:self.separatorView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
    [self.view addGestureRecognizer:tapGesture];
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
    
    // reset lastPhotoDate key after logout
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastPhotoDate"];
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
        UIColor *color = [UIColor colorWithRed:0.53 green:0.52 blue:0.52 alpha:1];
        _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    }
    return _emailTextField;
}

- (CCTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[CCTextField alloc] init];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        UIColor *color = [UIColor colorWithRed:0.53 green:0.52 blue:0.52 alpha:1];
        _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
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
        _signInButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _signInButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.47 blue:0.58 alpha:1];
        [_signInButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        _signInButton.layer.cornerRadius = 4.0;
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
    
     //uncomment to add sign in check
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![self.emailTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        hud.labelText = @"Loading";
        hud.mode = MBProgressHUDModeIndeterminate;
        [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self performTransition];
                });
            } else {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"Error";
                hud.detailsLabelText = [NSString stringWithFormat:@"%@", error.localizedDescription];
                [hud hide:YES afterDelay:2.0];
            }
        }];
    } else {
        hud.labelText = @"Error";
        hud.detailsLabelText = @"Fill all field";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
    }
}

- (void)performTransition {
    
    // present events
    /*
    CCEventsViewController *eventsVC = [[CCEventsViewController alloc] init];
    [self presentViewController:eventsVC animated:YES completion:^{
        
    }];
    */
    
    // present Stock and Tabs
    
    CCStockViewController *stockVC = [[CCStockViewController alloc] init];
    CCHistoryViewController *soldVC = [[CCHistoryViewController alloc] init];
    CCHistoryViewController *returnedVC = [[CCHistoryViewController alloc] init];
    UIViewController *tutorialVC = [[UIViewController alloc] init];
    UIViewController *statsVC = [[UIViewController alloc] init];
    
    UINavigationController *stockNavController = [[UINavigationController alloc] initWithRootViewController:stockVC];
    
    stockVC.title = @"Add Sale";
    soldVC.title = @"Sold";
    returnedVC.title = @"Returned";
    tutorialVC.title = @"Tutorial";
    statsVC.title = @"Report";
    
    soldVC.isShowingSold = YES;
    returnedVC.isShowingSold = NO;
    
    stockVC.tabBarItem.image = [UIImage imageNamed:@"plus_line"];
    stockVC.tabBarItem.selectedImage = [UIImage imageNamed:@"plus_fill"];
    soldVC.tabBarItem.image = [UIImage imageNamed:@"cart_full_line"];
    soldVC.tabBarItem.selectedImage = [UIImage imageNamed:@"cart_full_fill"];
    returnedVC.tabBarItem.image = [UIImage imageNamed:@"cart_empty_line"];
    returnedVC.tabBarItem.selectedImage = [UIImage imageNamed:@"cart_empty_fill"];
    tutorialVC.tabBarItem.image = [UIImage imageNamed:@"briefcase_line"];
    tutorialVC.tabBarItem.selectedImage = [UIImage imageNamed:@"briefcase_fill"];
    statsVC.tabBarItem.image = [UIImage imageNamed:@"calculator_line"];
    statsVC.tabBarItem.selectedImage = [UIImage imageNamed:@"calculator_fill"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[tutorialVC, returnedVC, stockNavController, soldVC, statsVC];
    [tabBarController setSelectedViewController:stockNavController];
    
    [self presentViewController:tabBarController animated:YES completion:^{

    }];
    
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
