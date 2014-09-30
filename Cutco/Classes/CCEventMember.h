//
//  CCEventMember.h
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Parse/Parse.h>
#import "CCEvent.h"

@interface CCEventMember : PFObject <PFSubclassing>

@property (retain) CCEvent *event;
@property (retain) PFUser *user;
@property BOOL primaryMember;

@end
