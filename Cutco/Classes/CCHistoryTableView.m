//
//  CCHistoryTableView.m
//  Cutco
//
//  Created by Dima Cheverda on 9/18/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCHistoryTableView.h"

@interface CCHistoryTableView ()

@end

@implementation CCHistoryTableView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [self addSubview:_refreshControl];
        self.rowHeight = 60.0f;
        self.allowsSelectionDuringEditing = NO;
        self.contentInset = UIEdgeInsetsMake(20.0, 0.0, 49.0, 0.0);
    }
    return self;
}

@end
