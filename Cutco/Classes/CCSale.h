//
//  CCSale.h
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCStockItem.h"
#import "CCEvent.h"
#import "CCEvents.h"

@interface CCSale : PFObject <PFSubclassing>

@property (retain) CCStockItem *stockItem;
@property (retain) PFUser *user;
@property BOOL returned;
@property NSUInteger price;
@property (retain) CCEvent *event;

- (instancetype)initWithStockItem:(CCStockItem *)stockItem;

@end
