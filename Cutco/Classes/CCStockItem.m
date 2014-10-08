//
//  CCStockItem.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockItem.h"
#import <Parse/PFObject+Subclass.h>

@interface CCStockItem ()

@end

@implementation CCStockItem

@dynamic name;
@dynamic description;
@dynamic UPC;
@dynamic retailPrice;
@dynamic salePrice;
@dynamic image;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"StockItem";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@                 UPC:  %lu", self.name, self.UPC];
}

@end