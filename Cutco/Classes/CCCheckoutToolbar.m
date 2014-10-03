//
//  CCCheckoutToolbar.m
//  Cutco
//
//  Created by Dima Cheverda on 10/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckoutToolbar.h"

@interface CCCheckoutToolbar ()

@property (strong, nonatomic) UIBarButtonItem *checkoutButton;

@end

@implementation CCCheckoutToolbar

- (instancetype)init {
    self = [super init];
    if (self) {
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
        [self setItems:@[self.cancelButton, spaceItem, self.checkoutButton, spaceItem, spaceItem]];
        self.translucent = NO;
    }
    return self;
}

- (UIBarButtonItem *)checkoutButton {
    if (!_checkoutButton) {
        _checkoutButton = [[UIBarButtonItem alloc] init];
        _checkoutButton.title = @"CHECKOUT";
        _checkoutButton.tintColor = [UIColor colorWithRed:0.11 green:0.82 blue:0.69 alpha:1];
    }
    return _checkoutButton;
}

@end
