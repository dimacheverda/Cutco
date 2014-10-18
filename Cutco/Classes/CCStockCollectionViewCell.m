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
//        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.checkMark];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        self.imageView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    }
    return self;
}

#define kCheckmarkSize 30.0
#define kCheckmarkPadding 10.0

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0.0,
                                  0.0,
                                  CGRectGetWidth(self.contentView.frame),
                                  CGRectGetWidth(self.contentView.frame) / 4.0 * 3.0);
    _imageView.center = CGPointMake(CGRectGetMidX(self.contentView.frame), CGRectGetMidY(self.contentView.frame));
    
    _checkMark.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - kCheckmarkSize - kCheckmarkPadding,
                                  CGRectGetMaxY(self.contentView.frame) - kCheckmarkSize - kCheckmarkPadding,
                                  kCheckmarkSize,
                                  kCheckmarkSize);
    
    _titleLabel.frame = CGRectMake(0.0,
                                   CGRectGetMaxY(self.imageView.frame) + 4.0,
                                   CGRectGetWidth(self.contentView.frame),
                                   CGRectGetHeight(self.contentView.frame) / 3 - 8.0);
}

#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor imagePlaceholderColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    }
    return _titleLabel;
}

- (CCCheckMark *)checkMark {
    if (!_checkMark) {
        _checkMark = [[CCCheckMark alloc] init];
        _checkMark.backgroundColor = [UIColor clearColor];
    }
    return  _checkMark;
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

@end
