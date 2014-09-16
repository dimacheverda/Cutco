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
        _date = [NSDate date];
        _user = [PFUser currentUser];
        _stockItem = [stockItem getPFObject];
        _returned = NO;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    self = [super init];
    if (self) {
        _date = object[@"date"];
        _user = [PFUser currentUser];
        _stockItem = object[@"stock_item"];
        _returned = [object[@"returned"] boolValue];
    }
    return self;
}

- (PFObject *)getPFObject {
    PFObject *object = [[PFObject alloc] initWithClassName:@"Sale"];
    object[@"date"] = self.date;
    object[@"user"] = self.user;
    object[@"stock_item"] = [PFObject objectWithoutDataWithClassName:@"StockItem" objectId:self.stockItem.objectId];
    object[@"returned"] = [NSNumber numberWithBool:self.returned];
    return object;
}

@end
