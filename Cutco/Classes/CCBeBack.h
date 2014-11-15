//
//  CCBeBack.h
//  Cutco
//
//  Created by Dima Cheverda on 11/15/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Parse/Parse.h>
#import "CCEvent.h"
#import "CCLocation.h"

@interface CCBeBack : PFObject <PFSubclassing>

@property (retain) CCEvent *event;
@property (retain) CCLocation *location;
@property (retain) PFUser *user;

@end
