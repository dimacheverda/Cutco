//
//  CCSale.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCSale.h"
#import <Parse/PFObject+Subclass.h>

@interface CCSale ()

@end

@implementation CCSale

@dynamic stockItem;
@dynamic user;
@dynamic returned;
@dynamic price;
@dynamic event;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Sale";
}

- (instancetype)initWithStockItem:(CCStockItem *)stockItem {
    self = [super init];
    if (self) {
        self.stockItem = stockItem;
        self.user = [PFUser currentUser];
        self.returned = NO;
        self.price = stockItem.salePrice;
        self.event = [[CCEvents sharedEvents] currentEvent];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"stockItem: %@      event: %@      returned: %d", self.stockItem.objectId, self.event.objectId, self.returned];
}

@end