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

#pragma mark - Accessors

#define CELL_HEIGHT 68.0

- (UIImageView *)stockImageView {
    if (!_stockImageView) {
        _stockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0,
                                                                        2.0,
                                                                        (CELL_HEIGHT - 4.0) / 2.0 * 3.0,
                                                                        CELL_HEIGHT - 4.0)];
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

#define BUTTON_HEIGHT 30.0
#define QUANTITY_ITEMS_SPACING 15.0

- (UIButton *)minusButton {
    if (!_minusButton) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.stockImageView.frame) + 20.0,
                                  (CELL_HEIGHT - BUTTON_HEIGHT) / 2,
                                  BUTTON_HEIGHT,
                                  BUTTON_HEIGHT);
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _minusButton.frame = frame;
        [_minusButton setTitle:@"-" forState:UIControlStateNormal];
        _minusButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [_minusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        _minusButton.tag = 0;
    }
    return _minusButton;
}

- (UIButton *)plusButton {
    if (!_plusButton) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.quantityLabel.frame) + QUANTITY_ITEMS_SPACING,
                                  CGRectGetMinY(self.minusButton.frame),
                                  BUTTON_HEIGHT,
                                  BUTTON_HEIGHT);
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusButton.frame = frame;
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        _plusButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [_plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        _plusButton.tag = 1;
    }
    return _plusButton;
}

- (UILabel *)quantityLabel {
    if (!_quantityLabel) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.minusButton.frame) + QUANTITY_ITEMS_SPACING,
                                  CGRectGetMinY(self.minusButton.frame),
                                  BUTTON_HEIGHT,
                                  BUTTON_HEIGHT);
        _quantityLabel = [[UILabel alloc] initWithFrame:frame];
        _quantityLabel.numberOfLines = 1;
        _quantityLabel.textAlignment = NSTextAlignmentCenter;
        _quantityLabel.font = [UIFont systemFontOfSize:22.0];
        _quantityLabel.text = @"1";
    }
    return _quantityLabel;
}

@end
