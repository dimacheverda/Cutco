//
//  CCEventMember.m
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEventMember.h"
#import <Parse/PFObject+Subclass.h>

@implementation CCEventMember

@dynamic event;
@dynamic user;
@dynamic primaryMember;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"EventMember";
}

@end
