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
    NSDate *today = [NSDate date];
    if (([beginDate compare:today] == NSOrderedAscending) && ([endDate compare:today] == NSOrderedDescending)) {
        return YES;
    }
    return NO;
}

+ (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [[calendar dateByAddingComponents:components toDate:[NSDate beginningOfDay] options:0] dateByAddingTimeInterval:-1];
}

@end
