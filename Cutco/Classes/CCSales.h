//
//  CCSales.h
//  Cutco
//
//  Created by Dima Cheverda on 9/24/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSale.h"

@interface CCSales : NSObject

@property (nonatomic, retain) NSMutableArray *sales;
@property (nonatomic, retain) NSMutableArray *returned;

+ (instancetype)sharedSales;
- (void)addSale:(CCSale *)sale;
- (void)moveSaleToReturnedAtIndex:(NSUInteger)index;

@end
