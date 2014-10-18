//
//  CCPopoverDismissal.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCPopoverDismissal.h"

@implementation CCPopoverDismissal

#pragma mark - Init

- (instancetype)initWithCheckoutSuccess:(BOOL)success {
    self = [super init];
    if (self) {
        self.checkoutSuccessful = success;
    }
    return self;
}

#pragma mark - Transitioning Delegate

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect presentedFrame = [transitionContext initialFrameForViewController:fromVC];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:10.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.isCheckoutSuccessful) {
                             fromVC.view.frame = CGRectMake(CGRectGetMinX(presentedFrame),
                                                            -CGRectGetMaxY(toVC.view.frame),
                                                            CGRectGetWidth(presentedFrame),
                                                            CGRectGetHeight(presentedFrame));
                         } else {
                             fromVC.view.frame = CGRectMake(CGRectGetMinX(presentedFrame),
                                                            CGRectGetMaxY(toVC.view.frame),
                                                            CGRectGetWidth(presentedFrame),
                                                            CGRectGetHeight(presentedFrame));
                         }
                         [[transitionContext containerView] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end
