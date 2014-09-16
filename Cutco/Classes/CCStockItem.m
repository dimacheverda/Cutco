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
        _salePrice = object[@"salePrice"];
        _retailPrice = object[@"retailPrice"];
        PFFile *imageFile = object[@"image"];
        _image = [UIImage imageWithData:[imageFile getData]];
        _objectId = object.objectId;
    }
    return self;
}

- (PFObject *)getPFObject {
    PFObject *object = [[PFObject alloc] initWithClassName:@"StockItem"];
    object[@"name"] = self.name;
    object[@"description"] = self.itemDescription;
    object[@"retailPrice"] = self.retailPrice;
    object[@"salePrice"] = self.salePrice;
    object[@"UPC"] = self.UPC;
    object[@"image"] = [PFFile fileWithData:UIImagePNGRepresentation(self.image)];
    object.objectId = self.objectId;
    return object;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"objectId : %@,\nUPC : %@,\nname : %@,\ndescription : %@,\nsale_price : %@,\nretail_price : %@\n", _objectId,_UPC,_name,_itemDescription,_salePrice,_retailPrice];
}

@end