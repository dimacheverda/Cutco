//
//  CCCheckoutViewController.h
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCCheckoutTableViewControllerDelegate;

@interface CCCheckoutViewController : UIViewController

@property (weak, nonatomic) id <CCCheckoutTableViewControllerDelegate> delegate;

- (instancetype)initWithStockItems:(NSArray *)items;

@end

@protocol CCCheckoutTableViewControllerDelegate <NSObject>

- (void)checkoutWillDismiss;

@end