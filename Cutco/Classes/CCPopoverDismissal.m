//
//  CCPopoverDismissal.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCPopoverDismissal.h"

@implementation CCPopoverDismissal

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect presentedFrame = [transitionContext initialFrameForViewController:fromVC];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  fromVC.view.frame = CGRectMake(CGRectGetMinX(presentedFrame),
                                                                                 -CGRectGetMaxY(toVC.view.frame),
                                                                                 CGRectGetWidth(presentedFrame),
                                                                                 CGRectGetHeight(presentedFrame));
                                                  [[transitionContext containerView] setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
                                              }
                                              completion:^(BOOL finished) {
                                                  [transitionContext completeTransition:YES];
                                              }];
}

@end
