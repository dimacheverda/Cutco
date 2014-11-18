//
//  CCCheckBox.h
//  Cutco
//
//  Created by Dima Cheverda on 11/2/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCheckBox : UIView

@property (nonatomic, getter=isChecked) BOOL checked;
@property (nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) UIColor *boundsColor;
@property (strong, nonatomic) UIColor *checkmarkColor;

@end
