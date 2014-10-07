//
//  CCStock.m
//  Cutco
//
//  Created by Dima Cheverda on 9/24/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStock.h"

@implementation CCStock

+ (instancetype)sharedStock {
    static CCStock *sharedStock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStock = [[self alloc] init];
    });
    return sharedStock;
}

- (id)init {
    if (self = [super init]) {
        self.items = [NSArray array];
        self.isStockLoaded = NO;
    }
    return self;
}

- (CCStockItem *)itemForObjectId:(NSString *)objectId {
    __block CCStockItem *item = [[CCStockItem alloc] init];
    [[CCStock sharedStock].items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCStockItem *object = (CCStockItem *)obj;
        if ([object.objectId isEqualToString:objectId]) {
            item = object;
            *stop = YES;
        }
    }];
    return item;
}

@end