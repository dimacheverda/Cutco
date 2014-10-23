//
//  CCCounterView.h
//  Cutco
//
//  Created by Dima Cheverda on 10/11/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCounterView : UIView

@property (nonatomic) NSUInteger count;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

@end
