//
//  CCStockItemView.m
//  Cutco
//
//  Created by Dima Cheverda on 9/18/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockItemView.h"

@implementation CCStockItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.descriptionLabel];
        [self addSubview:self.retailPriceLabel];
        [self addSubview:self.salePriceLabel];
        [self addSubview:self.UPCLabel];
    }
    return self;
}

#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
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

@end
