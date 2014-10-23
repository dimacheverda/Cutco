//
//  CCHistoryTableViewCell.h
//  Cutco
//
//  Created by Dima Cheverda on 9/17/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL returned;
@property (nonatomic) NSInteger index;

@end
