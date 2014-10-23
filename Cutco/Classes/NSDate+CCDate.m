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
    if (self) {
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *todayComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
        NSDateComponents *selfComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self];
        
        if ([todayComp year] == [selfComp year] && [todayComp month] == [selfComp month] && [todayComp day] == [selfComp day]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate {
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *begin = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:beginDate];
    NSDateComponents *end = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:endDate];
    
    if (today.year < begin.year || today.year > end.year) {
        return NO;
    } else if (today.month < begin.month || today.month > end.month) {
        return NO;
    } else if (today.day < begin.day || today.day > end.day) {
        return NO;
    }
    return YES;
}

@end
