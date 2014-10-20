//
//  CCHistoryTableViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 9/17/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCHistoryTableViewCell.h"
#import "UIColor+CCColor.h"

@interface CCHistoryTableViewCell ()

@property (strong, nonatomic) UIImageView *itemImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *indexLabel;

@end

@implementation CCHistoryTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.itemImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

#define kIndexLabelWidth 40.0
#define kCellHeight (self.contentView.frame.size.height)

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _indexLabel.frame = CGRectMake(2.0,
                                   4.0,
                                   kIndexLabelWidth ,
                                   kCellHeight / 2 - 2.0);
    
    _itemImageView.frame = CGRectMake(CGRectGetMaxX(self.indexLabel.frame) + 2.0,
                                      4.0,
                                      (kCellHeight - 8.0), // / 3.0 * 4.0,
                                      kCellHeight - 8.0);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(self.itemImageView.frame) + 8.0,
                                  4.0,
                                  CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.itemImageView.frame) - 12.0,
                                  kCellHeight / 2 - 2.0);
    _dateLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame),
                                  CGRectGetMaxY(self.nameLabel.frame),
                                  CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.itemImageView.frame) - 12.0,
                                  kCellHeight / 2 - 2.0);
    
//    [self applyShadowForImageView:_itemImageView];
}

#pragma mark - Accessors

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%d", (int)_index];
}

- (void)setImage:(UIImage *)image {
    if (image) {
        _image = image;
        self.itemImageView.image = _image;
        self.itemImageView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setName:(NSString *)name {
    if (name) {
        _name = name;
        self.nameLabel.text = _name;
    }
}

- (void)setDate:(NSDate *)date {
    if (date) {
        _date = date;
        self.dateLabel.text = [NSDateFormatter localizedStringFromDate:_date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    }
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.numberOfLines = 1;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor placeholderTextColor];
    }
    return _indexLabel;
}

- (UIImageView *)itemImageView {
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _itemImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        _dateLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _dateLabel;
}

- (void)applyShadowForImageView:(UIImageView *)imageView {
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    imageView.layer.shadowOpacity = 0.8;
    imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
    imageView.layer.shadowRadius = 1.0;
    imageView.clipsToBounds = NO;
}

@end