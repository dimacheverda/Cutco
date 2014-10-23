//
//  CCPhoto.m
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCPhoto.h"
#import <Parse/PFObject+Subclass.h>

@implementation CCPhoto

@dynamic file;
@dynamic user;
@dynamic event;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Photo";
}

@end
