//
//  CCCounterView.m
//  Cutco
//
//  Created by Dima Cheverda on 10/11/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCounterView.h"
#import "UIColor+CCColor.h"

@interface CCCounterView ()

@property (strong, nonatomic) NSString *placeholder;
@property (strong, nonatomic) UILabel *counterLabel;

@end

@implementation CCCounterView

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.placeholder = placeholder;
        self.count = 0;
        
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        toolbar.barTintColor = [UIColor countToolbarTintColor];
        [self insertSubview:toolbar atIndex:0];
        
        [self addSubview:self.counterLabel];
    }
    return self;
}

- (UILabel *)counterLabel {
    if (!_counterLabel) {
        _counterLabel = [[UILabel alloc] init];
        _counterLabel.frame = CGRectMake(0.0, 20.0, 320.0, 44.0);//CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _counterLabel.numberOfLines = 1;
        _counterLabel.textAlignment = NSTextAlignmentCenter;
        _counterLabel.font = [UIFont systemFontOfSize:16.0];
        _counterLabel.textColor = [UIColor darkTextColor];
        _counterLabel.text = [NSString stringWithFormat:@"%@ %d", self.placeholder, (int)self.count];
    }
    return _counterLabel;
}

- (void)setCount:(NSUInteger)count {
    _count = count;
    self.counterLabel.text = [NSString stringWithFormat:@"%@ %d", self.placeholder, (int)count];
}

@end
