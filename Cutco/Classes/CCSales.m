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
        self.sales = [NSArray array];
    }
    return self;
}

@end
