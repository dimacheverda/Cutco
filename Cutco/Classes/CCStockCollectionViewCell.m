//
//  CCStockCollectionViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 9/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockCollectionViewCell.h"

@interface CCStockCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CCStockCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGRect frame = CGRectMake(0.0,
                                  0.0,
                                  CGRectGetWidth(self.contentView.frame),
                                  CGRectGetWidth(self.contentView.frame)/3*2);
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor = [UIColor brownColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGRect frame = CGRectMake(0.0,
                                  CGRectGetMaxY(self.imageView.frame) + 4.0,
                                  CGRectGetWidth(self.contentView.frame),
                                  CGRectGetHeight(self.contentView.frame) / 3 - 8.0);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.numberOfLines = 2;
//        _titleLabel.backgroundColor = [UIColor greenColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

@end
