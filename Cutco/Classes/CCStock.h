//
//  CCStock.h
//  Cutco
//
//  Created by Dima Cheverda on 9/24/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCStockItem.h"

@interface CCStock : NSObject

@property (nonatomic, retain) NSArray *items;

+ (instancetype)sharedStock;
- (CCStockItem *)itemForObjectId:(NSString *)objectId;

@end
