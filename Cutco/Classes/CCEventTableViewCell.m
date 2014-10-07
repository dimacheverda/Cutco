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

@end

@implementation CCEventTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.locationTitleLabel];
        [self.contentView addSubview:self.startAtLabel];
        [self.contentView addSubview:self.endAtLabel];
    
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - Accessors

- (UILabel *)locationTitleLabel {
    if (!_locationTitleLabel) {
        CGRect frame = CGRectMake(16.0,
                                  4.0,
                                  CGRectGetWidth(self.contentView.frame) - 16.0 - 32.0,
                                  40.0);
        _locationTitleLabel = [[UILabel alloc] initWithFrame:frame];
        _locationTitleLabel.numberOfLines = 0;
        _locationTitleLabel.textAlignment = NSTextAlignmentLeft;
        _locationTitleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _locationTitleLabel;
}

- (UILabel *)startAtLabel {
    if (!_startAtLabel) {
        UILabel *startAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0,
                                                                          CGRectGetMaxY(self.locationTitleLabel.frame) + 10.0,
                                                                          60.0,
                                                                          16.0)];
        startAtLabel.numberOfLines = 1;
        startAtLabel.font = [UIFont systemFontOfSize:13.0];
        startAtLabel.text = @"Start At:";
        startAtLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:startAtLabel];
        
        CGRect frame = CGRectMake(CGRectGetMaxX(startAtLabel.frame),
                                  CGRectGetMaxY(self.locationTitleLabel.frame) + 10.0,
                                  CGRectGetWidth(self.contentView.frame) / 2,
                                  16.0);
        _startAtLabel = [[UILabel alloc] initWithFrame:frame];
        _startAtLabel.numberOfLines = 1;
        _startAtLabel.textAlignment = NSTextAlignmentLeft;
        _startAtLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _startAtLabel;
}

- (UILabel *)endAtLabel {
    if (!_endAtLabel) {
        UILabel *endAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0,
                                                                        CGRectGetMaxY(self.startAtLabel.frame) + 4.0,
                                                                        60.0,
                                                                        16.0)];
        endAtLabel.numberOfLines = 1;
        endAtLabel.font = [UIFont systemFontOfSize:13.0];
        endAtLabel.text = @"End At:";
        endAtLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:endAtLabel];
        
        CGRect frame = CGRectMake(CGRectGetMaxX(endAtLabel.frame),
                                  CGRectGetMaxY(self.startAtLabel.frame) + 4.0,
                                  CGRectGetWidth(self.contentView.frame) / 2,
                                  16.0);
        _endAtLabel = [[UILabel alloc] initWithFrame:frame];
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
