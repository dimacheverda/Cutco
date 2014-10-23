//
//  CCPhoto.h
//  Cutco
//
//  Created by Dima Cheverda on 9/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <Parse/Parse.h>
#import "CCEvent.h"

@interface CCPhoto : PFObject <PFSubclassing>

@property (retain) PFFile *file;
@property (retain) PFUser *user;
@property (retain) CCEvent *event;

@end
