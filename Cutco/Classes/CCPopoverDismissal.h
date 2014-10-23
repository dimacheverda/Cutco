//
//  CCPopoverDismissal.h
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCPopoverDismissal : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, getter=isCheckoutSuccessful) BOOL checkoutSuccessful;

- (instancetype)initWithCheckoutSuccess:(BOOL)success;

@end
