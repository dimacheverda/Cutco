//
//  CCHistoryTableViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 9/17/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCHistoryTableViewCell.h"

@interface CCHistoryTableViewCell ()

@property (strong, nonatomic) UIImageView *itemImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation CCHistoryTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.itemImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

#pragma mark - Accessors

- (void)setImage:(UIImage *)image {
    self.itemImageView.image = image;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setDate:(NSDate *)date {
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
}

- (UIImageView *)itemImageView {
    if (!_itemImageView) {
        CGRect frame = CGRectMake(2.0,
                                  2.0,
                                  CGRectGetWidth(self.contentView.frame) / 4,
                                  CGRectGetHeight(self.contentView.frame) - 4.0);
        _itemImageView = [[UIImageView alloc] initWithFrame:frame];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _itemImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.itemImageView.frame) + 4.0,
                                  2.0,
                                  CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.itemImageView.frame) - 12.0,
                                  CGRectGetHeight(self.contentView.frame) / 2 - 2.0);
        _nameLabel = [[UILabel alloc] initWithFrame:frame];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame),
                                  CGRectGetMaxY(self.nameLabel.frame) + 4.0,
                                  CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.itemImageView.frame) - 12.0,
                                  CGRectGetHeight(self.contentView.frame) / 2 - 2.0);
        _dateLabel = [[UILabel alloc] initWithFrame:frame];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}

@end