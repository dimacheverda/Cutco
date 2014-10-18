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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.checkoutButton];
        [self addSubview:self.cancelButton];
        _checkoutButton.center = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetHeight(frame) / 2.0);
        _cancelButton.center = CGPointMake(CGRectGetMidX(_cancelButton.frame), CGRectGetHeight(frame) / 2.0);
    }
    return self;
}

- (void)layoutSubviews {
    _cancelButton.frame = CGRectMake(0.0,
                                     0.0,
                                     CGRectGetWidth(self.frame) / 3.0,
                                     CGRectGetHeight(self.frame));
    _checkoutButton.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame),
                                       0.0,
                                       CGRectGetWidth(self.frame) - CGRectGetWidth(_cancelButton.frame),
                                       CGRectGetHeight(self.frame));
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setImage:[UIImage imageNamed:@"x-mark"] forState:UIControlStateNormal];
        _cancelButton.contentMode = UIViewContentModeCenter;
        _cancelButton.tintColor = [UIColor whiteColor];
        _cancelButton.backgroundColor = [UIColor checkoutToolbarCancelColor];
    }
    return _cancelButton;
}

- (UIButton *)checkoutButton {
    if (!_checkoutButton) {
        _checkoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_checkoutButton setTitle:@"Checkout" forState:UIControlStateNormal];
        [_checkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkoutButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _checkoutButton.backgroundColor = [UIColor checkoutToolbarCheckoutColor];
    }
    return _checkoutButton;
}

@end
