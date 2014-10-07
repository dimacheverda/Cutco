//
//  CCEvents.h
//  Cutco
//
//  Created by Dima Cheverda on 10/7/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCEvent.h"
#import "CCEventMember.h"
#import "CCLocation.h"

@interface CCEvents : NSObject

@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, retain) NSArray *eventsMember;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) CCEvent *currentEvent;
@property (nonatomic, retain) CCEventMember *currentEventMember;
@property (nonatomic, retain) CCLocation *currentLocation;
 
+ (instancetype)sharedEvents;

@end
