//
//  NSDate+CCDate.h
//  Cutco
//
//  Created by Dima Cheverda on 9/16/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCDate)

- (BOOL)isCurrentDay;
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end