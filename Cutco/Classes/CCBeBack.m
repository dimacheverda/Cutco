//
//  CCBeBack.m
//  Cutco
//
//  Created by Dima Cheverda on 11/15/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCBeBack.h"
#import <Parse/PFObject+Subclass.h>

@implementation CCBeBack

@dynamic event;
@dynamic location;
@dynamic user;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BeBack";
}

@end
