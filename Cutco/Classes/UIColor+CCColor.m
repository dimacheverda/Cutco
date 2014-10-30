//
//  UIColor+CCColor.m
//  Cutco
//
//  Created by Dima Cheverda on 10/17/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "UIColor+CCColor.h"

@implementation UIColor (CCColor)

+ (UIColor *)signInButtonColor {
    return [UIColor colorWithRed:0.18 green:0.47 blue:0.58 alpha:1];
}

+ (UIColor *)placeholderTextColor {
    return [UIColor colorWithRed:0.53 green:0.52 blue:0.52 alpha:1];
}

+ (UIColor *)checkmarkColor {
    return [UIColor colorWithRed:0.078 green:0.435 blue:0.875 alpha:1];
}

+ (UIColor *)checkmarkGrayTranslucentColor {
    return [UIColor colorWithWhite:1.0 alpha:0.6];
}

+ (UIColor *)checkoutButtonColor {
    return [UIColor colorWithRed:0.11 green:0.82 blue:0.69 alpha:1];
}

+ (UIColor *)checkoutConfirmColor {
    return [UIColor colorWithRed:0.40 green:0.79 blue:0.52 alpha:1];
}

+ (UIColor *)checkoutCancelColor {
    return [UIColor colorWithRed:0.32 green:0.64 blue:0.42 alpha:1];
}

+ (UIColor *)textFieldTextColor {
    return [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
}

+ (UIColor *)imagePlaceholderColor {
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}

+ (UIColor *)countToolbarTintColor {
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}

+ (UIColor *)checkoutToolbarCancelColor {
    return [UIColor colorWithRed:0.38 green:0.63 blue:0.87 alpha:1];
}

+ (UIColor *)checkoutToolbarCheckoutColor {
    return [UIColor colorWithRed:0.45 green:0.71 blue:0.95 alpha:1];
}

+ (UIColor *)stockCheckedTintColor {
    return [UIColor colorWithWhite:0.8 alpha:0.2];
}

+ (UIColor *)historyTableViewSeparatorColor {
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

+ (UIColor *)historyTableViewCellNameColor {
    return [UIColor colorWithWhite:0.1 alpha:1.0];
}

+ (UIColor *)historyTableViewCellDateColor {
    return [UIColor colorWithWhite:0.3 alpha:1.0];
}

+ (UIColor *)checkoutViewBackgroundColor {
    return [UIColor colorWithWhite:0.7 alpha:1.0];
}

+ (UIColor *)stockItemTitleBackgroundColor {
    return [UIColor colorWithWhite:0.5 alpha:0.5];
}

+ (UIColor *)stockCollectionViewBackgroundColor {
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

@end
