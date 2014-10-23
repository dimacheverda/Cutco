//
//  CCTutorialViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 10/23/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCTutorialViewController.h"

@interface CCTutorialViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CCTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageNamed:@"coming-soon"];
    [self.view addSubview:self.imageView];
}

@end
