//
//  CCSales.h
//  Cutco
//
//  Created by Dima Cheverda on 9/24/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSale.h"
#import "CCTransaction.h"
#import "CCBeBack.h"

@interface CCSales : NSObject

@property (nonatomic, retain) NSMutableArray *sales;
@property (nonatomic, retain) NSMutableArray *returned;
@property (nonatomic, retain) NSMutableArray *transactions;
@property (nonatomic, retain) NSMutableArray *beBacks;
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;

+ (instancetype)sharedSales;

- (void)loadSalesFromParseWithCompletion:(void (^)(NSError *error))completion;

- (void)addSale:(CCSale *)sale;
- (void)moveSaleToReturnedAtIndex:(NSUInteger)index;
- (void)clearAllData;

@end
