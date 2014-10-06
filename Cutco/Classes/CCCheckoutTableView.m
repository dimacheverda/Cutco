//
//  CCCheckoutTableView.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckoutTableView.h"

@implementation CCCheckoutTableView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.rowHeight = 68.0;
        self.allowsSelection = NO;
    }
    return self;
}

@end
