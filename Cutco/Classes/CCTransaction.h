//
//  CCTransaction.h
//  Cutco
//
//  Created by Dima Cheverda on 11/11/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Parse/Parse.h>
#import "CCEvent.h"
#import "CCLocation.h"

@interface CCTransaction : PFObject <PFSubclassing>

@property (retain) PFUser *user;
@property (retain) CCEvent *event;
@property (retain) CCLocation *location;
@property BOOL newCustomer;
@property BOOL cameBack;

@end
