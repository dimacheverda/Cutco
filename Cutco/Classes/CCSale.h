//
//  CCSale.h
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCStockItem.h"

@interface CCSale : NSObject

@property (strong, nonatomic) CCStockItem *stockItem;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic) BOOL returned;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *objectId;

- (instancetype)initWithStockItem:(CCStockItem *)stockItem;
- (instancetype)initWithPFObject:(PFObject *)object;
- (PFObject *)getPFObject;

@end
