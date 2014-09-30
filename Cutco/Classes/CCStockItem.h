//
//  CCStockItem.h
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CCStockItem : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *description;
@property NSUInteger UPC;
@property NSUInteger retailPrice;
@property NSUInteger salePrice;
@property (retain) PFFile *image;

@end
