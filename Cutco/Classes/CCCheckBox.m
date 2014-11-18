//
//  CCCheckBox.m
//  Cutco
//
//  Created by Dima Cheverda on 11/2/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckBox.h"
#import "UIColor+CCColor.h"
#import "UIColor+CCCutcoColors.h"

@implementation CCCheckBox

- (void)drawRect:(CGRect)rect {

    //// Color Declarations
    UIColor* backgroundColor = [UIColor whiteColor];
    UIColor* strokeColor = [UIColor cutcoDarkGray];
    
    CGFloat fullHeight = CGRectGetHeight(rect);
    CGFloat fullWidth = CGRectGetWidth(rect);
    
    if (self.cornerRadius == 0) {
        self.cornerRadius = 4.0;
    }
    
    //// Bounds Drawing
    UIBezierPath* boundsPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1.0, 1.0, fullWidth - 2.0, fullHeight - 2.0) cornerRadius:self.cornerRadius];
    [backgroundColor setFill];
    [boundsPath fill];
    [strokeColor setStroke];
    boundsPath.lineWidth = 2;
    [boundsPath stroke];
    
    if (self.isChecked) {
        
        //// Checkmark Drawing
        UIBezierPath* checkmarkPath = [UIBezierPath bezierPath];
        [checkmarkPath moveToPoint: CGPointMake(0.18 * fullWidth,
                                                0.5082 * fullHeight)];
        [checkmarkPath addLineToPoint: CGPointMake(0.4343 * fullWidth,
                                                   0.78 * fullHeight)];
        [checkmarkPath addLineToPoint: CGPointMake(0.83 * fullWidth,
                                                   0.22 * fullHeight)];
        [backgroundColor setFill];
        [checkmarkPath fill];
        [strokeColor setStroke];
        checkmarkPath.lineWidth = 3;
        [checkmarkPath stroke];
    }
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    [self setNeedsDisplay];
}

@end
