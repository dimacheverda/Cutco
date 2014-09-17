//
//  NSDate+CCDate.m
//  Cutco
//
//  Created by Dima Cheverda on 9/16/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "NSDate+CCDate.h"

@implementation NSDate (CCDate)

- (BOOL)isCurrentDay {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *todayComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
    NSDateComponents *selfComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self];
    
    NSLog(@"hours %d", [todayComp hour]);
    
    if ([todayComp year] == [selfComp year] && [todayComp month] == [selfComp month] && [todayComp day] == [selfComp day]) {
        return YES;
    }
    return NO;
}

@end
