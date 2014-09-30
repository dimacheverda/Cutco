//
//  CCEvent.m
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEvent.h"
#import <Parse/PFObject+Subclass.h>

@implementation CCEvent

@dynamic location;
@dynamic startAt;
@dynamic endAt;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Event";
}

@end
