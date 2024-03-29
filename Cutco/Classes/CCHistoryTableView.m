//
//  CCHistoryTableView.m
//  Cutco
//
//  Created by Dima Cheverda on 9/18/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCHistoryTableView.h"
#import "UIColor+CCColor.h"

@interface CCHistoryTableView ()

@end

@implementation CCHistoryTableView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [self addSubview:_refreshControl];
        [self sendSubviewToBack:_refreshControl];
        self.allowsSelectionDuringEditing = NO;
        self.contentInset = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
        self.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0);
        self.separatorColor = [UIColor historyTableViewSeparatorColor];
    }
    return self;
}

@end
