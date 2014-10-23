//
//  CCLocation.m
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCLocation.h"
#import <Parse/PFObject+Subclass.h>

@implementation CCLocation

@dynamic title;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Location";
}

@end
