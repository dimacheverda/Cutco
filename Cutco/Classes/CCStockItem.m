//
//  CCStockItem.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockItem.h"

@implementation CCStockItem

- (instancetype)initWithPFObject:(PFObject *)object {
    self = [super init];
    if (self) {
        _UPC = object[@"UPC"];
        _name = object[@"name"];
        _itemDescription = object[@"description"];
        _salePrice = object[@"sale_price"];
        _retailPrice = object[@"retail_price"];
        PFFile *imageFile = object[@"image"];
        _image = [UIImage imageWithData:[imageFile getData]];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"UPC : %@,\nname : %@,\ndescription : %@,\nsale_price : %@,\nretail_price : %@\n", _UPC,_name,_itemDescription,_salePrice,_retailPrice];
}

@end