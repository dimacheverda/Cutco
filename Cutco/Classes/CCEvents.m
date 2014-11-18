//
//  CCEvents.m
//  Cutco
//
//  Created by Dima Cheverda on 10/7/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEvents.h"
#import "NSDate+CCDate.h"

@implementation CCEvents

+ (instancetype)sharedEvents {
    static CCEvents *sharedEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvents = [[self alloc] init];
    });
    return sharedEvents;
}

- (id)init {
    if (self = [super init]) {
        self.allEvents = [NSArray array];
        self.closedEvents = [NSArray array];
        self.inProgressEvents = [NSArray array];
        self.upcommingEvents = [NSArray array];
        self.eventsMember = [NSArray array];
        self.locations = [NSArray array];
    }
    return self;
}

- (void)setAllEvents:(NSArray *)allEvents {
    if (allEvents) {
        _allEvents = allEvents;
        
        NSMutableArray *closed = [NSMutableArray array];
        NSMutableArray *inProgress = [NSMutableArray array];
        NSMutableArray *upcomming = [NSMutableArray array];
        NSDate *today = [NSDate date];
        
        for (CCEvent *event in allEvents) {
            if ([today isBetweenDate:event.startAt andDate:event.endAt]) {
                [inProgress addObject:event];
            } else if ([event.startAt compare:today] == NSOrderedDescending) {                  //// startAt is later in time than today
                [upcomming addObject:event];
            } else if ([event.endAt compare:today] == NSOrderedAscending) {                     //// endAt is earlier in time than today
                [closed addObject:event];
            }
        }
        
        self.closedEvents = [self sortedArrayByDate:closed withKey:@"startAt"];
        self.inProgressEvents = [self sortedArrayByDate:inProgress withKey:@"startAt"];
        self.upcommingEvents = [self sortedArrayByDate:upcomming withKey:@"startAt"];
    }
}

- (NSArray *)sortedArrayByDate:(NSArray *)array withKey:(NSString *)key {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *descriptors=  [NSArray arrayWithObject:descriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

@end
