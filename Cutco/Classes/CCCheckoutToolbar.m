//
//  CCCheckoutToolbar.m
//  Cutco
//
//  Created by Dima Cheverda on 10/1/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckoutToolbar.h"
#import "UIColor+CCColor.h"

@interface CCCheckoutToolbar ()

@end

@implementation CCCheckoutToolbar

- (instancetype)init {
    self = [super init];
    if (self) {
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
        [self setItems:@[self.cancelButton, spaceItem, self.checkoutButton, spaceItem, spaceItem]];
        self.translucent = NO;
//        self.backgroundColor = 
    }
    return self;
}

- (UIBarButtonItem *)checkoutButton {
    if (!_checkoutButton) {
        _checkoutButton = [[UIBarButtonItem alloc] init];
        
        _checkoutButton.title = @"CHECKOUT";
        _checkoutButton.tintColor = [UIColor checkoutButtonColor];
    }
    return _checkoutButton;
}

@end
