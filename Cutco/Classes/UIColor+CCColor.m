//
//  UIColor+CCColor.m
//  Cutco
//
//  Created by Dima Cheverda on 10/17/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "UIColor+CCColor.h"
#import "UIColor+CCCutcoColors.h"

@implementation UIColor (CCColor)

#pragma mark - Sign In

+ (UIColor *)signInButtonColor {
    return [UIColor cutcoBlue];
}

+ (UIColor *)placeholderTextColor {
    return [UIColor colorWithRed:0.53 green:0.52 blue:0.52 alpha:1];
}

+ (UIColor *)textFieldTextColor {
    return [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
}

#pragma mark - Events

+ (UIColor *)eventTypeSegmentedControlTintColor {
    return [UIColor cutcoLightBlue];
}

#pragma mark - Stock Items

+ (UIColor *)stockCollectionViewBackgroundColor {
//    return [UIColor colorWithWhite:0.9 alpha:1.0];
    return [UIColor cutcoWhite];
}

#pragma mark - -- Checkmark

+ (UIColor *)checkmarkColor {
    return [UIColor cutcoLightBlue];
}

+ (UIColor *)checkmarkGrayTranslucentColor {
    return [UIColor colorWithWhite:1.0 alpha:0.6];
}


#pragma mark - -- Toolbar

+ (UIColor *)checkoutToolbarCancelColor {
    return [UIColor cutcoBlue];
}

+ (UIColor *)checkoutToolbarCheckoutColor {
    return [UIColor cutcoLightBlue];
}

#pragma mark - -- Stock Items Cell

+ (UIColor *)stockItemTitleBackgroundColor {
    return [UIColor colorWithWhite:0.3 alpha:0.5];
}

+ (UIColor *)stockItemTitleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)imagePlaceholderColor {
    return [UIColor whiteColor];
}

+ (UIColor *)stockCheckedTintColor {
    return [UIColor colorWithWhite:0.8 alpha:0.2];
}

#pragma mark - Checkout View

+ (UIColor *)checkoutViewBackgroundColor {
    return [UIColor cutcoGrayBlue];
}

+ (UIColor *)checkoutConfirmColor {
    return [UIColor cutcoLightBlue];
}

+ (UIColor *)checkoutCancelColor {
    return [UIColor cutcoBlue];
}

#pragma mark - History

+ (UIColor *)countToolbarTintColor {
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
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

@end
