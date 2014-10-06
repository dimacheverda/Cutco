//
//  CCEventTableViewCell.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCEventTableViewCell.h"

@interface CCEventTableViewCell ()

@end

@implementation CCEventTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.locationTitleLabel];
        [self.contentView addSubview:self.startAtLabel];
        [self.contentView addSubview:self.endAtLabel];
    
        UILabel *startAtLabel = [[UILabel alloc] initWithFrame:self.startAtLabel.frame];
        startAtLabel.numberOfLines = 1;
        startAtLabel.font = [UIFont systemFontOfSize:13.0];
        startAtLabel.text = @"Start At:";
        startAtLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:startAtLabel];
        
        UILabel *endAtLabel = [[UILabel alloc] initWithFrame:self.endAtLabel.frame];
        endAtLabel.numberOfLines = 1;
        endAtLabel.font = [UIFont systemFontOfSize:13.0];
        endAtLabel.text = @"End At:";
        endAtLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:endAtLabel];
        
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
        CGRect frame = CGRectMake(16.0,
                                  CGRectGetMaxY(self.locationTitleLabel.frame) + 10.0,
                                  CGRectGetWidth(self.contentView.frame) / 2.5,
                                  16.0);
        _startAtLabel = [[UILabel alloc] initWithFrame:frame];
        _startAtLabel.numberOfLines = 1;
        _startAtLabel.textAlignment = NSTextAlignmentRight;
        _startAtLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _startAtLabel;
}

- (UILabel *)endAtLabel {
    if (!_endAtLabel) {
        CGRect frame = CGRectMake(16.0,
                                  CGRectGetMaxY(self.startAtLabel.frame) + 4.0,
                                  CGRectGetWidth(self.contentView.frame) / 2.5,
                                  16.0);
        _endAtLabel = [[UILabel alloc] initWithFrame:frame];
        _endAtLabel.numberOfLines = 1;
        _endAtLabel.textAlignment = NSTextAlignmentRight;
        _endAtLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _endAtLabel;
}

@end
