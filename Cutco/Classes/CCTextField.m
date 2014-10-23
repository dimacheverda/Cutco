//
//  CCTextField.m
//  Cutco
//
//  Created by Dima Cheverda on 10/7/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCTextField.h"
#import "UIFont+CCFont.h"
#import "UIColor+CCColor.h"

@implementation CCTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.keyboardType = UIKeyboardTypeDefault;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.borderStyle = UITextBorderStyleNone;
        self.textColor = [UIColor textFieldTextColor];
        self.clearButtonMode = UITextFieldViewModeNever;
        self.tintColor = [UIColor lightTextColor];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont signInFont];
    }
    return self;
}

@end
