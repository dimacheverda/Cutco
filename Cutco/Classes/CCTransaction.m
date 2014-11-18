//
//  CCTransaction.m
//  Cutco
//
//  Created by Dima Cheverda on 11/11/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCTransaction.h"
#import <Parse/PFObject+Subclass.h>

@implementation CCTransaction

@dynamic event;
@dynamic user;
@dynamic location;
@dynamic newCustomer;
@dynamic cameBack;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Transaction";
}

@end
