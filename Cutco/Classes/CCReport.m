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

@property (strong, nonatomic) CCEvent *currentEvent;

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
    self.currentEvent = [CCEvents sharedEvents].currentEvent;
    
    // set Overview numbers
    self.totalSalesNumber = [NSNumber numberWithUnsignedInteger:[CCSales sharedSales].sales.count];
    self.totalReturnedNumber = [NSNumber numberWithUnsignedInteger:[CCSales sharedSales].returned.count];
    self.totalSalesRevenue = [NSNumber numberWithUnsignedInteger:[[[CCSales sharedSales].sales valueForKeyPath:@"@sum.price"] integerValue]];
 
    // set today numbers
    NSUInteger soldToday = 0;
    NSUInteger revenueToday = 0;
    NSUInteger returnedToday = 0;
    
    for (CCSale *sale in [CCSales sharedSales].sales) {
        if ([sale.createdAt isCurrentDay]) {
            soldToday++;
            revenueToday += sale.price;
        }
    }
    for (CCSale *sale in [CCSales sharedSales].returned) {
        if ([sale.createdAt isCurrentDay]) {
            returnedToday++;
        }
    }
    
    self.todaySalesNumber = [NSNumber numberWithUnsignedInteger:soldToday];
    self.todayReturnedNumber = [NSNumber numberWithUnsignedInteger:returnedToday];
    self.todaySalesRevenue = [NSNumber numberWithUnsignedInteger:revenueToday];
    
    [self postNotification];
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
