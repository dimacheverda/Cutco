//
//  CCPopoverTransition.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCPopoverTransition.h"

@implementation CCPopoverTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

#define TOP_PADDING 80.0
#define LEFT_PADDING 20.0

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
    CGFloat height = CGRectGetHeight(fullFrame);
    toVC.view.frame = CGRectMake(fullFrame.origin.x + LEFT_PADDING,
                                 height + 16.0 + TOP_PADDING,
                                 CGRectGetWidth(fullFrame) - LEFT_PADDING*2,
                                 height - TOP_PADDING*2);

    [[transitionContext containerView] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [[transitionContext containerView] addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:10.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toVC.view.frame = CGRectMake(LEFT_PADDING,
                                                      TOP_PADDING,
                                                      CGRectGetWidth(fullFrame) - LEFT_PADDING*2,
                                                      height - TOP_PADDING*2);
                         [[transitionContext containerView] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
                         
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end
