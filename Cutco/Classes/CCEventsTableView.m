//
//  CCEventsTableView.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEventsTableView.h"

@implementation CCEventsTableView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.rowHeight = 96.0;
        self.contentInset = UIEdgeInsetsMake(44.0, 0.0, 0.0, 0.0);
        
        _refreshControl = [[UIRefreshControl alloc] init];
        [self addSubview:_refreshControl];
        [self sendSubviewToBack:_refreshControl];
    }
    return self;
}

@end
