//
//  CCEventTableViewCell.h
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCEventTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSDate *startAt;
@property (strong, nonatomic) NSDate *endAt;

@end
