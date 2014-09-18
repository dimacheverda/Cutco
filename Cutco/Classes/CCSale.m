//
//  CCSale.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCSale.h"

@interface CCSale ()

@end

@implementation CCSale

- (instancetype)initWithStockItem:(CCStockItem *)stockItem {
    self = [super init];
    if (self) {
        _user = [PFUser currentUser];
        _stockItem = stockItem;
        _returned = NO;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    self = [super init];
    if (self) {
        _user = [PFUser currentUser];
        _stockItem = object[@"stockItem"];
        _returned = [object[@"returned"] boolValue];
        _createdAt = object.createdAt;
    }
    return self;
}

- (PFObject *)getPFObject {
    PFObject *object = [[PFObject alloc] initWithClassName:@"Sale"];
    object[@"user"] = self.user;
    object[@"stockItem"] = [PFObject objectWithoutDataWithClassName:@"StockItem" objectId:self.stockItem.objectId];
    object[@"returned"] = [NSNumber numberWithBool:self.returned];
    return object;
}

@end