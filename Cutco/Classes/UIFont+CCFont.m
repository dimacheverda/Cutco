//
//  UIFont+CCFont.m
//  Cutco
//
//  Created by Dima Cheverda on 10/7/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "UIFont+CCFont.h"

@implementation UIFont (CCFont)

+ (UIFont *)signInFont {
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithFontAttributes:@{
                                                                                  UIFontDescriptorFamilyAttribute: @"Helvetica Neue",
                                                                                  UIFontDescriptorNameAttribute: @"HelveticaNeue-Light"
                                                                                  }];
    
    UIFont *font = [UIFont fontWithDescriptor:desc size:20.0];
    return font;
}

@end
