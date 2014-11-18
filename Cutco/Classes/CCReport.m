//
//  CCReport.m
//  Cutco
//
//  Created by Dima Cheverda on 10/31/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCReport.h"
#import "CCEvents.h"
#import "CCEvent.h"
#import "CCSales.h"
#import "CCSale.h"
#import "NSDate+CCDate.h"

@interface CCReport ()

@end

@implementation CCReport

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.totalSalesNumber = @0;
        self.totalReturnedNumber = @0;
        self.totalSalesRevenue = @0;
        self.totalBeBacks = @0;
        self.totalCameBacks = @0;
        
        self.todaySalesNumber = @0;
        self.todayReturnedNumber = @0;
        self.todaySalesRevenue = @0;
        self.todayBeBacks = @0;
        self.todayCameBacks = @0;
    }
    return self;
}

#pragma mark - Calculate Methods

- (void)updateReportData {
    if (![CCSales sharedSales].isLoaded) {
        [[CCSales sharedSales] loadSalesFromParseWithCompletion:^(NSError *error) {
            if (!error) {
                [self calculateData];
            }
        }];
    } else {
        [self calculateData];
    }
}

- (void)calculateData {
    
    [self calculateTotalData];
 
    [self calculateTodayData];
    
    [self postNotification];
}

- (void)calculateTotalData {
    NSMutableArray *transactions = [CCSales sharedSales].transactions;
    NSMutableArray *beBacks = [CCSales sharedSales].beBacks;
    NSMutableArray *sales = [CCSales sharedSales].sales;
    
    self.totalSalesNumber = [NSNumber numberWithUnsignedInteger:sales.count];
    self.totalReturnedNumber = [NSNumber numberWithUnsignedInteger:[CCSales sharedSales].returned.count];
    self.totalSalesRevenue = [NSNumber numberWithDouble:[[sales valueForKeyPath:@"@sum.price"] doubleValue]];
    self.totalBeBacks = [NSNumber numberWithUnsignedInteger:beBacks.count];
    self.totalCameBacks = [NSNumber numberWithUnsignedInteger:[[transactions valueForKeyPath:@"@sum.cameBack"] unsignedIntegerValue]];
    self.totalCameBackPercentage = [NSNumber numberWithDouble:([self.totalCameBacks doubleValue] / [self.totalBeBacks doubleValue] * 100)];
    self.totalNewCustomers = [NSNumber numberWithUnsignedInteger:[[transactions valueForKeyPath:@"@sum.newCustomer"] unsignedIntegerValue]];
}

- (void)calculateTodayData {
    NSUInteger sold = 0;
    NSUInteger returned = 0;
    CGFloat revenue = 0.0;
    NSUInteger beBack = 0;
    NSUInteger cameBack = 0;
    NSUInteger newCustomers = 0;
    
    for (CCSale *sale in [CCSales sharedSales].sales) {
        if ([sale.createdAt isCurrentDay]) {
            sold++;
            revenue += sale.price;
        }
    }
    for (CCSale *sale in [CCSales sharedSales].returned) {
        if ([sale.updatedAt isCurrentDay]) {
            returned++;
        }
    }
    
    for (CCBeBack *beback in [CCSales sharedSales].beBacks) {
        if ([beback.createdAt isCurrentDay]) {
            beBack++;
        }
    }
    
    for (CCTransaction *transaction in [CCSales sharedSales].transactions) {
        if ([transaction.createdAt isCurrentDay]) {
            if (transaction.cameBack) {
                cameBack++;
            }
            if (transaction.newCustomer) {
                newCustomers++;
            }
        }
    }
    
    self.todaySalesNumber = [NSNumber numberWithUnsignedInteger:sold];
    self.todayReturnedNumber = [NSNumber numberWithUnsignedInteger:returned];
    self.todaySalesRevenue = [NSNumber numberWithDouble:revenue];
    self.todayBeBacks = [NSNumber numberWithUnsignedInteger:beBack];
    self.todayCameBacks = [NSNumber numberWithUnsignedInteger:cameBack];
    self.todayCameBackPercentage = [NSNumber numberWithDouble:([self.todayCameBacks doubleValue] / [self.todayBeBacks doubleValue] * 100)];
    self.todayNewCustomers = [NSNumber numberWithUnsignedInteger:newCustomers];
}

#define kReportUpdatedNotificationName @"kReportUpdatedNotificationName"

- (void)postNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kReportUpdatedNotificationName object:nil];
}

- (NSInteger)daysBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return [components day];
}

@end
