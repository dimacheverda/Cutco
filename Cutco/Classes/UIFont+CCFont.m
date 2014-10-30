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
                                                                                  UIFontDescriptorFamilyAttribute: @"Myriad Pro",
                                                                                  UIFontDescriptorNameAttribute: @"MyriadPro-Light"
                                                                                  }];
    
    UIFont *font = [UIFont fontWithDescriptor:desc size:20.0];
    return font;
}

+ (UIFont *)primaryHeadlineTypefaceWithSize:(CGFloat)size {
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithFontAttributes:@{
                                                                                  UIFontDescriptorFamilyAttribute: @"Marion",
                                                                                  UIFontDescriptorNameAttribute: @"Marion-Regular"
                                                                                  }];
    
    UIFont *font = [UIFont fontWithDescriptor:desc size:size];
    return font;
}

+ (UIFont *)primaryCopyTypefaceWithSize:(CGFloat)size {
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithFontAttributes:@{
                                                                                  UIFontDescriptorFamilyAttribute: @"Myriad Pro",
                                                                                  UIFontDescriptorNameAttribute: @"MyriadPro-Regular"
                                                                                  }];
    UIFont *font = [UIFont fontWithDescriptor:desc size:size];
    return font;
}

@end
