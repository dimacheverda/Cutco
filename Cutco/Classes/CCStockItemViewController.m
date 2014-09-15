//
//  CCStockItemViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockItemViewController.h"

@interface CCStockItemViewController ()

@property (strong, nonatomic) CCStockItem *stockItem;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation CCStockItemViewController

#pragma mark - Init

- (instancetype)initWithStockItem:(CCStockItem *)stockItem {
    self = [super init];
    if (self) {
        _stockItem = stockItem;
    }
    return self;
}

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveSaleButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Sale"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(saveSaveButtonDidPressed)];
    self.navigationItem.rightBarButtonItem = saveSaleButton;
    
    [self.view addSubview:self.imageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // image view
    _imageView.frame = CGRectMake(8.0,
                                  8.0 + 64.0,
                                  CGRectGetWidth(self.view.frame) - 16.0,
                                  CGRectGetWidth(self.view.frame) / 2);
    
}

#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.stockItem.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageView;
}

#pragma mark - Action Handlers

- (void)saveSaveButtonDidPressed {
    NSLog(@"save sale!");
}

@end