//
//  CCStockItemViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockItemViewController.h"
#import <Parse/Parse.h>


@interface CCStockItemViewController ()

@property (strong, nonatomic) CCStockItem *stockItem;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *retailPriceLabel;
@property (strong, nonatomic) UILabel *salePriceLabel;
@property (strong, nonatomic) UILabel *UPCLabel;

@end

@implementation CCStockItemViewController

#pragma mark - Init

- (instancetype)initWithStockItem:(CCStockItem *)stockItem {
    self = [super init];
    if (self) {
        _stockItem = stockItem;
        self.view.backgroundColor = [UIColor whiteColor];
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
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.retailPriceLabel];
    [self.view addSubview:self.salePriceLabel];
    [self.view addSubview:self.UPCLabel];

    self.nameLabel.text = self.stockItem.name;
    self.descriptionLabel.text = self.stockItem.itemDescription;
    self.retailPriceLabel.text = [NSString stringWithFormat:@"$%@", [self.stockItem.retailPrice stringValue]];
    self.salePriceLabel.text = [NSString stringWithFormat:@"$%@", [self.stockItem.salePrice stringValue]];
    self.UPCLabel.text = [self.stockItem.UPC stringValue];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat textOffset = 20.0;
    CGRect rect;
    
    _imageView.frame = CGRectMake(8.0,
                                  8.0 + 64.0,
                                  CGRectGetWidth(self.view.frame) - 16.0,
                                  CGRectGetWidth(self.view.frame) / 2);
    
    rect = [self calculateFrameForText:_nameLabel.text font:_nameLabel.font];
    _nameLabel.frame = CGRectMake(textOffset,
                                  CGRectGetMaxY(_imageView.frame) + 8.0,
                                  CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                  CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:_descriptionLabel.text font:_descriptionLabel.font];
    _descriptionLabel.frame = CGRectMake(textOffset,
                                         CGRectGetMaxY(_nameLabel.frame) + 8.0,
                                         CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                         CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:_retailPriceLabel.text font:_retailPriceLabel.font];
    _retailPriceLabel.frame = CGRectMake(textOffset,
                                         CGRectGetMaxY(_descriptionLabel.frame) + 8.0,
                                         CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                         CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:self.salePriceLabel.text font:self.salePriceLabel.font];
    _salePriceLabel.frame = CGRectMake(textOffset,
                                       CGRectGetMaxY(_retailPriceLabel.frame) + 8.0,
                                       CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                       CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:self.UPCLabel.text font:self.UPCLabel.font];
    self.UPCLabel.frame = CGRectMake(textOffset,
                                     CGRectGetMaxY(self.salePriceLabel.frame) + 8.0,
                                     CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                     CGRectGetHeight(rect));
}

#pragma mark - Label Calculations

- (CGRect)calculateFrameForText:(NSString *)text font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 20 * 2, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect;
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descriptionLabel;
}


- (UILabel *)retailPriceLabel {
    if (!_retailPriceLabel) {
        _retailPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _retailPriceLabel.numberOfLines = 0;
        _retailPriceLabel.font = [UIFont systemFontOfSize:13.0f];
        _retailPriceLabel.textAlignment = NSTextAlignmentRight;
    }
   return _retailPriceLabel;
}

- (UILabel *)salePriceLabel {
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _salePriceLabel.numberOfLines = 0;
        _salePriceLabel.font = [UIFont systemFontOfSize:13.0f];
        _salePriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _salePriceLabel;
}

- (UILabel *)UPCLabel {
    if (!_UPCLabel) {
        _UPCLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _UPCLabel.numberOfLines = 0;
        _UPCLabel.font = [UIFont systemFontOfSize:13.0f];
        _UPCLabel.textAlignment = NSTextAlignmentRight;
    }
    return _UPCLabel;
}

#pragma mark - Action Handlers

- (void)saveSaveButtonDidPressed {
    
    
    NSLog(@"save sale!");
    
}

@end