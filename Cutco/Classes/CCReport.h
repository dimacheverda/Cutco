//
//  CCReport.h
//  Cutco
//
//  Created by Dima Cheverda on 10/31/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCReport : NSObject

@property (strong, nonatomic) NSNumber *totalSalesNumber;
@property (strong, nonatomic) NSNumber *totalReturnedNumber;
@property (strong, nonatomic) NSNumber *totalSalesRevenue;
@property (strong, nonatomic) NSNumber *totalBeBacks;
@property (strong, nonatomic) NSNumber *totalCameBacks;
@property (strong, nonatomic) NSNumber *totalCameBackPercentage;
@property (strong, nonatomic) NSNumber *totalNewCustomers;
@property (strong, nonatomic) NSNumber *totalOldCustomers;

@property (strong, nonatomic) NSNumber *todaySalesNumber;
@property (strong, nonatomic) NSNumber *todayReturnedNumber;
@property (strong, nonatomic) NSNumber *todaySalesRevenue;
@property (strong, nonatomic) NSNumber *todayBeBacks;
@property (strong, nonatomic) NSNumber *todayCameBacks;
@property (strong, nonatomic) NSNumber *todayCameBackPercentage;
@property (strong, nonatomic) NSNumber *todayNewCustomers;
@property (strong, nonatomic) NSNumber *todayOldCustomers;

@property (strong, nonatomic) NSArray *days;
@property (strong, nonatomic) NSArray *salesPerDay;
@property (strong, nonatomic) NSArray *revenuePerDay;

- (void)updateReportData;

@end
