//
//  CCEventTableViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEventTableViewCell.h"

@interface CCEventTableViewCell ()

@property (strong, nonatomic) UILabel *locationTitleLabel;
@property (strong, nonatomic) UILabel *startAtLabel;
@property (strong, nonatomic) UILabel *endAtLabel;
@property (strong, nonatomic) UILabel *startAtPlaceholder;
@property (strong, nonatomic) UILabel *endAtPlaceholder;

@end

@implementation CCEventTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.locationTitleLabel];
//        [self.contentView addSubview:self.startAtPlaceholder];
        [self.contentView addSubview:self.startAtLabel];
//        [self.contentView addSubview:self.endAtPlaceholder];
        [self.contentView addSubview:self.endAtLabel];
    
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _locationTitleLabel.frame = CGRectMake(16.0,
                                           4.0,
                                           CGRectGetWidth(self.contentView.frame) - 16.0 - 32.0,
                                           40.0);
    
    _startAtPlaceholder.frame = CGRectMake(16.0,
                                           CGRectGetMaxY(self.locationTitleLabel.frame) + 10.0,
                                           60.0,
                                           16.0);
    
    _startAtLabel.frame = CGRectMake(CGRectGetMaxX(self.startAtPlaceholder.frame),
                                     CGRectGetMaxY(self.locationTitleLabel.frame) + 10.0,
                                     CGRectGetWidth(self.contentView.frame) / 2,
                                     16.0);
    
    _endAtPlaceholder.frame = CGRectMake(16.0,
                                         CGRectGetMaxY(self.startAtPlaceholder.frame) + 4.0,
                                         60.0,
                                         16.0);
    
    _endAtLabel.frame = CGRectMake(CGRectGetMaxX(self.endAtPlaceholder.frame),
                                   CGRectGetMaxY(self.startAtLabel.frame) + 4.0,
                                   CGRectGetWidth(self.contentView.frame) / 2,
                                   16.0);
}

#pragma mark - Accessors

- (UILabel *)locationTitleLabel {
    if (!_locationTitleLabel) {
        _locationTitleLabel = [[UILabel alloc] init];
        _locationTitleLabel.numberOfLines = 0;
        _locationTitleLabel.textAlignment = NSTextAlignmentLeft;
        _locationTitleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _locationTitleLabel;
}

- (UILabel *)startAtLabel {
    if (!_startAtLabel) {
        self.startAtPlaceholder = [[UILabel alloc] init];
        self.startAtPlaceholder.numberOfLines = 1;
        self.startAtPlaceholder.font = [UIFont systemFontOfSize:13.0];
        self.startAtPlaceholder.text = @"Start At:";
        self.startAtPlaceholder.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.startAtPlaceholder];
        
        _startAtLabel = [[UILabel alloc] init];
        _startAtLabel.numberOfLines = 1;
        _startAtLabel.textAlignment = NSTextAlignmentLeft;
        _startAtLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _startAtLabel;
}

- (UILabel *)endAtLabel {
    if (!_endAtLabel) {
        self.endAtPlaceholder = [[UILabel alloc] init];
        self.endAtPlaceholder.numberOfLines = 1;
        self.endAtPlaceholder.font = [UIFont systemFontOfSize:13.0];
        self.endAtPlaceholder.text = @"End At:";
        self.endAtPlaceholder.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.endAtPlaceholder];
        
        _endAtLabel = [[UILabel alloc] init];
        _endAtLabel.numberOfLines = 1;
        _endAtLabel.textAlignment = NSTextAlignmentLeft;
        _endAtLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _endAtLabel;
}

- (void)setLocation:(NSString *)location {
    self.locationTitleLabel.text = location;
}

- (void)setStartAt:(NSDate *)startAt {
    self.startAtLabel.text = [NSDateFormatter localizedStringFromDate:startAt dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

- (void)setEndAt:(NSDate *)endAt {
    self.endAtLabel.text = [NSDateFormatter localizedStringFromDate:endAt dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

@end
