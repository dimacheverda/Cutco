//
//  CCOnboardingViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 11/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCOnboardingViewController.h"

@interface CCOnboardingViewController ()

@property (strong, nonatomic) UIBarButtonItem *backBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *nextBarButtonItem;
@property (nonatomic) NSUInteger currentIndex;

typedef NS_ENUM(NSInteger, kMFWalkthroughDirection) {
    kMFWalkthroughDirectionForward,
    kMFWalkthroughDirectionBackward
};

@end

@implementation CCOnboardingViewController

#pragma mark - Init

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    self = [super init];
    if (self) {
        _viewControllers = viewControllers;
    }
    return self;
}

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.nextBarButtonItem;
    
    [self displayInitialViewController];
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        _backBarButtonItem.enabled = NO;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)nextBarButtonItem {
    if (!_nextBarButtonItem) {
        _nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
        _nextBarButtonItem.enabled = NO;
    }
    return _nextBarButtonItem;
}


- (void)displayInitialViewController {
    self.currentIndex = 0;
    UIViewController *viewController = [self.viewControllers firstObject];
    
    viewController.view.frame = self.view.frame;
    self.title = viewController.title;
    
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)cycleFromViewController:(UIViewController *)oldC
               toViewController:(UIViewController *)newC
                  withDirection:(kMFWalkthroughDirection)direction {
    [oldC willMoveToParentViewController:nil];
    [self addChildViewController:newC];
    
    newC.view.frame = [self newViewStartFrameWithDirection:direction];
    CGRect endFrame = [self oldViewEndFrameWithDirection:direction];
    
    [self transitionFromViewController:oldC toViewController:newC duration:0.25 options:0
                            animations:^{
                                newC.view.frame = oldC.view.frame;
                                oldC.view.frame = endFrame;
                            } completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];
                                [newC didMoveToParentViewController:self];
                                self.title = newC.title;
                            }];
}

- (CGRect)newViewStartFrameWithDirection:(kMFWalkthroughDirection)direction {
    if (direction == kMFWalkthroughDirectionForward) {
        return CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        return CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (CGRect)oldViewEndFrameWithDirection:(kMFWalkthroughDirection)direction {
    if (direction == kMFWalkthroughDirectionForward) {
        return CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        return CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)displayNextViewController {
    UIViewController *currentViewController = [self.viewControllers objectAtIndex:self.currentIndex];
    UIViewController *newViewController = [self.viewControllers objectAtIndex:++self.currentIndex];
    
    [self cycleFromViewController:currentViewController
                 toViewController:newViewController
                    withDirection:kMFWalkthroughDirectionForward];
    
    
//    if (self.currentIndex == self.viewControllers.count - 1) {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    } else {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
}

- (void)displayPreviousViewController {
    UIViewController *currentViewController = [self.viewControllers objectAtIndex:self.currentIndex];
    UIViewController *newViewController = [self.viewControllers objectAtIndex:--self.currentIndex];
    
    [self cycleFromViewController:currentViewController
                 toViewController:newViewController
                    withDirection:kMFWalkthroughDirectionBackward];
    
//    if (self.currentIndex == 0) {
//        self.navigationItem.leftBarButtonItem.enabled = NO;
//    } else {
//        self.navigationItem.leftBarButtonItem.enabled = YES;
//    }
}

#pragma mark - Navigation Actions

- (void)goBack {
    if (self.currentIndex == 0) {
        return;
    } else {
        [self displayPreviousViewController];
    }
}

- (void)goForward {
    if (self.currentIndex == self.viewControllers.count - 1) {
        return;
    } else {
        [self displayNextViewController];
    }

}
@end
