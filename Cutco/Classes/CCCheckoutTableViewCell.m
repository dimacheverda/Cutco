//
//  CCCheckoutTableViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckoutTableViewCell.h"

@interface CCCheckoutTableViewCell ()

@property (strong, nonatomic) UIImageView *stockImageView;

@end

@implementation CCCheckoutTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.stockImageView];
        [self.contentView addSubview:self.minusButton];
        [self.contentView addSubview:self.quantityLabel];
        [self.contentView addSubview:self.plusButton];
    }
    return self;
}

#define kCellHeight CGRectGetHeight(self.contentView.frame)
#define kButtonHeight (CGRectGetHeight(self.contentView.frame) / 2.0)
#define kQuantityButtonsOffset 10.0

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _stockImageView.frame = CGRectMake(0.0,
                                       0.0,
                                       kCellHeight,
                                       kCellHeight);
    
    _quantityLabel.frame = CGRectMake(0.0,
                                      0.0,
                                      kButtonHeight / 2.0,
                                      kButtonHeight);
    
    CGFloat quantityCenterX = ((CGRectGetWidth(self.frame) - CGRectGetMaxX(_stockImageView.frame)) / 2.0) + CGRectGetMaxX(_stockImageView.frame);
    _quantityLabel.center =  CGPointMake(quantityCenterX,
                                         CGRectGetHeight(self.frame) / 2.0);
    
    _minusButton.frame = CGRectMake(0.0,
                                    0.0,
                                    kButtonHeight,
                                    kButtonHeight);
    
    _minusButton.center = CGPointMake((CGRectGetMinX(_quantityLabel.frame) - CGRectGetMaxX(_stockImageView.frame)) / 2.0 + CGRectGetMaxX(_stockImageView.frame) + kQuantityButtonsOffset,
                                      CGRectGetMidY(_quantityLabel.frame));
    
    _plusButton.frame = CGRectMake(0.0,
                                   0.0,
                                   kButtonHeight,
                                   kButtonHeight);
    
    _plusButton.center = CGPointMake((CGRectGetMaxX(self.frame) - CGRectGetMaxX(_quantityLabel.frame)) / 2.0 + CGRectGetMaxX(_quantityLabel.frame) - kQuantityButtonsOffset,
                                     CGRectGetMidY(_quantityLabel.frame));
}

#pragma mark - Accessors


- (UIImageView *)stockImageView {
    if (!_stockImageView) {
        _stockImageView = [[UIImageView alloc] init];
        _stockImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _stockImageView;
}

- (void)setImage:(UIImage *)image {
    if (image) {
        _image = image;
        self.stockImageView.image = image;
    }
    [self.stockImageView setNeedsDisplay];
}

- (UIButton *)minusButton {
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        _minusButton.tag = 0;
    }
    return _minusButton;
}

- (UIButton *)plusButton {
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        _plusButton.tag = 1;
    }
    return _plusButton;
}

- (UILabel *)quantityLabel {
    if (!_quantityLabel) {
        _quantityLabel = [[UILabel alloc] init];
        _quantityLabel.numberOfLines = 1;
        _quantityLabel.textAlignment = NSTextAlignmentCenter;
        _quantityLabel.font = [UIFont systemFontOfSize:22.0];
        _quantityLabel.text = @"1";
    }
    return _quantityLabel;
}

@end
