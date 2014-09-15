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

@interface CCSignInViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *logoImage;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *signInButton;

@end

@implementation CCSignInViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.signInButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // image
    CGRect logoFrame = CGRectMake(20.0,
                                  50.0,
                                  CGRectGetWidth(self.view.frame) - 40,
                                  100.0);
    _logoImage.frame = logoFrame;
    
    // email text field
    _emailTextField.frame = CGRectMake(20.0,
                                       CGRectGetMaxY(_logoImage.frame) + 20.0,
                                       CGRectGetWidth(self.view.frame) - 40,
                                       30.0);
    
    // password text field
    _passwordTextField.frame = CGRectMake(20.0,
                                          CGRectGetMaxY(_emailTextField.frame) + 20.0,
                                          CGRectGetWidth(self.view.frame) - 40,
                                          30.0);
    
    // sign in button
    _signInButton.frame = CGRectMake(110.0,
                                     CGRectGetMaxY(_passwordTextField.frame) + 20,
                                     CGRectGetWidth(self.view.frame) - 220.0,
                                     44.0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}

#pragma mark - Accessors

- (UIImageView *)logoImage {
    if (!_logoImage) {
        
        _logoImage = [[UIImageView alloc] init];
        _logoImage.backgroundColor = [UIColor lightGrayColor];
    }
    return _logoImage;
}

- (UITextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.delegate = self;
        _emailTextField.placeholder = @"Username";
        _emailTextField.keyboardType = UIKeyboardTypeDefault;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.borderStyle = UITextBorderStyleBezel;
        _emailTextField.returnKeyType = UIReturnKeyNext;
    }
    return _emailTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.delegate = self;
        _passwordTextField.placeholder = @"Password";
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.borderStyle = UITextBorderStyleBezel;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
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
    }
    return _signInButton;
}

#pragma mark - Action Handlers

- (void)signInButtonDidPressed {
    /*
     //uncomment to add sign in check
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            hud.detailsLabelText = [NSString stringWithFormat:@"%@", error.description];
            [hud hide:YES afterDelay:2.0];
        }
    }];
     */
    
    [self performTransition];
}

- (void)performTransition {
    CCStockViewController *stockVC = [[CCStockViewController alloc] init];
    CCHistoryViewController *historyVC = [[CCHistoryViewController alloc] init];
    UIViewController *tutorialVC = [[UIViewController alloc] init];
    UIViewController *reportVC = [[UIViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:stockVC];
    
    stockVC.title = @"Stock";
    historyVC.title = @"History";
    tutorialVC.title = @"Tutorial";
    reportVC.title = @"Report";
    
    stockVC.tabBarItem.image = [UIImage imageNamed:@"cart"];
    historyVC.tabBarItem.image = [UIImage imageNamed:@"cart"];
    tutorialVC.tabBarItem.image = [UIImage imageNamed:@"cart"];
    reportVC.tabBarItem.image = [UIImage imageNamed:@"cart"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[navController, historyVC, tutorialVC, reportVC];
    
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
