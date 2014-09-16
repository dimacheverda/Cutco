//
//  CCStockItem.h
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CCStockItem : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSNumber *UPC;
@property (strong, nonatomic) NSNumber *retailPrice;
@property (strong, nonatomic) NSNumber *salePrice;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *objectId;

- (instancetype)initWithPFObject:(PFObject *)object;
- (PFObject *)getPFObject;

@end
