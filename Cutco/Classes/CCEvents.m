//
//  CCEvents.m
//  Cutco
//
//  Created by Dima Cheverda on 10/7/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEvents.h"

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
        self.eventsMember = [NSArray array];
        self.locations = [NSArray array];
    }
    return self;
}

@end
