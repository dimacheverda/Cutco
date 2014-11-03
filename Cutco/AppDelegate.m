//
//  AppDelegate.m
//  Cutco
//
//  Created by Dima Cheverda on 9/11/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>
#import "CCSignInViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIFont+CCFont.h"
#import "UIColor+CCColor.h"

@interface AppDelegate () {
    BOOL _allowRotation;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"in1P0XGnoUdnVtp9a2jXLU0f2NOcAsyiOpqQydgA"
                  clientKey:@"bYy7fEK59sNtpY1JJWtZkyvPksfKJgt54AT1NjLa"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Crashlytics startWithAPIKey:@"b4e0bfdc0e14fd2d3f5efc10f37ed1265a1520d8"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[CCSignInViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    // subscribe to MoviePlayer fullscreen entering
    _allowRotation = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDidEnterFullscreen)
                                                 name:MPMoviePlayerDidEnterFullscreenNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerWillExitFullscreen)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    
    [self applyAppearance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [PFUser logOut];
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//////    MAGIC GOES HERE!!!!!
    {
//    if ([[window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]] || [[window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"MPInlineVideoFullscreenViewController")] || [[window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
//        
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    } else {
//        
//        if ([[window.rootViewController presentedViewController] isKindOfClass:[UINavigationController class]]) {
//            
//            // look for it inside UINavigationController
//            UINavigationController *nc = (UINavigationController *)[window.rootViewController presentedViewController];
//            
//            // is at the top?
//            if ([nc.topViewController isKindOfClass:[MPMoviePlayerViewController class]]) {
//                return UIInterfaceOrientationMaskAllButUpsideDown;
//                
//                // or it's presented from the top?
//            } else if ([[nc.topViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]] ||
//                       [[nc.topViewController presentedViewController] isKindOfClass:NSClassFromString(@"MPInlineVideoFullscreenViewController")]) {
//                return UIInterfaceOrientationMaskAllButUpsideDown;
//            }
//        }
//    }
    }
    
    if (_allowRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)moviePlayerDidEnterFullscreen {
    _allowRotation = YES;
}

- (void)moviePlayerWillExitFullscreen {
    _allowRotation = NO;
}

- (void)applyAppearance {
    // changing UIBarButtonItem Appearance
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont primaryCopyTypefaceWithSize:17]
                                                           forKey:NSFontAttributeName];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // changing NavigationBar title appearance
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont primaryCopyTypefaceWithSize:20.0]
                                                           }];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor eventTypeSegmentedControlTintColor]];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor eventTypeSegmentedControlTintColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor eventTypeSegmentedControlTintColor]];
}

@end
