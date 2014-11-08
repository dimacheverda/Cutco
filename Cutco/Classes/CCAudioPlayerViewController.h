//
//  CCAudioPlayerViewController.h
//  Cutco
//
//  Created by Dima Cheverda on 11/5/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAudioPlayerViewController : UIViewController

@property (strong, nonatomic) NSURL *streamUrl;

- (instancetype)initWithStreamUrl:(NSURL *)streamUrl titleText:(NSString *)titleText;

@end
