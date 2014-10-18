//
//  CCStockCollectionViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 9/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockCollectionViewCell.h"
#import "UIColor+CCColor.h"

@interface CCStockCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CCStockCollectionViewCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.checkMark];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        CGRect frame = CGRectMake(0.0,
                                  0.0,
                                  CGRectGetWidth(self.contentView.frame),
                                  CGRectGetWidth(self.contentView.frame)/4*3);
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor imagePlaceholderColor];
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        self.titleLabel.text = _title;
    }
}

- (void)setImage:(UIImage *)image {
    if (image) {
        _image = image;
        self.imageView.image = _image;
        self.imageView.backgroundColor = [UIColor whiteColor];
    }
}

- (CCCheckMark *)checkMark {
    if (!_checkMark) {
        
        CGFloat checkmarkSize = 30.0;
        
        CGRect frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) - checkmarkSize,
                                  CGRectGetMaxY(self.imageView.frame) - checkmarkSize,
                                  checkmarkSize,
                                  checkmarkSize);
        _checkMark = [[CCCheckMark alloc] init];
        _checkMark.frame = frame;
        _checkMark.backgroundColor = [UIColor clearColor];
    }
    return  _checkMark;
}

@end
