//
//  CCSales.m
//  Cutco
//
//  Created by Dima Cheverda on 9/24/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCSales.h"

@implementation CCSales

+ (instancetype)sharedSales {
    static CCSales *sharedSales = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSales = [[self alloc] init];
    });
    return sharedSales;
}

- (id)init {
    if (self = [super init]) {
        self.sales = [NSMutableArray array];
        self.returned = [NSMutableArray array];
    }
    return self;
}

- (void)setSales:(NSMutableArray *)sales {
    if (sales) {
        NSMutableArray *returned = [NSMutableArray array];
        NSMutableArray *sold = [NSMutableArray array];
        for (CCSale *sale in sales) {
            if (sale.returned) {
                [returned insertObject:sale atIndex:0];
            } else {
                [sold insertObject:sale atIndex:0];
            }
        }
        
        _sales = [self sortedArrayByDate:sold];
        _returned = [self sortedArrayByDate:returned];
    }
}

- (void)addSale:(CCSale *)sale {
    if (sale) {
        NSMutableArray *array = [NSMutableArray array];
        if (sale.returned) {
            array = [_returned mutableCopy];
            [array insertObject:sale atIndex:0];
            _returned = [self sortedArrayByDate:array];
        } else {
            array = [_sales mutableCopy];
            [array insertObject:sale atIndex:0];
            _sales = [self sortedArrayByDate:array];
        }
    }
}

- (NSMutableArray *)sortedArrayByDate:(NSMutableArray *)array {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *descriptors=  [NSArray arrayWithObject:descriptor];
    NSMutableArray *sortedArray = (NSMutableArray *)[array sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

- (void)moveSaleToReturnedAtIndex:(NSUInteger)index {
    if (index < self.sales.count) {
        CCSale *sale = self.sales[index];
        sale.returned = YES;
        NSMutableArray *sold = [self.sales mutableCopy];
        NSMutableArray *returned = [self.returned mutableCopy];
        [sold removeObject:sale];
        [returned addObject:sale];
        self.sales = sold;
        self.returned = [self sortedArrayByDate:returned];
        
        [self postUpdateNotification];
    }
}

- (void)postUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"kSalesUpdatedNotificationName" object:nil]];
}

@end
