//
//  CCTextField.m
//  Cutco
//
//  Created by Dima Cheverda on 10/7/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCTextField.h"
#import "UIFont+CCFont.h"

@implementation CCTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.keyboardType = UIKeyboardTypeDefault;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.borderStyle = UITextBorderStyleNone;
        self.textColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
        self.clearButtonMode = UITextFieldViewModeNever;
        self.tintColor = [UIColor lightTextColor];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont signInFont];
    }
    return self;
}

@end
