//
//  CCEvent.h
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Parse/Parse.h>
#import "CCLocation.h"

@interface CCEvent : PFObject <PFSubclassing>

@property (retain) CCLocation *location;
@property (retain) NSDate *startAt;
@property (retain) NSDate *endAt;

+ (NSString *)parseClassName;

@end
