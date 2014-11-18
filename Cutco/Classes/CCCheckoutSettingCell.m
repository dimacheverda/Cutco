//
//  CCCheckoutSettingCell.m
//  Cutco
//
//  Created by Dima Cheverda on 10/30/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckoutSettingCell.h"
#import "UIFont+CCFont.h"

@implementation CCCheckoutSettingCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.settingNameLabel];
        [self.contentView addSubview:self.switchButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _settingNameLabel.frame = CGRectMake(16.0,
                                         0.0,
                                         CGRectGetWidth(self.contentView.frame),
                                         CGRectGetHeight(self.contentView.frame));
    
    _switchButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 60.0,
                                     0.0,
                                     64.0,
                                     CGRectGetHeight(self.contentView.frame));
    _switchButton.center = CGPointMake(CGRectGetMidX(_switchButton.frame),
                                       CGRectGetMidY(_settingNameLabel.frame));
}

#pragma mark - Accessors

- (UILabel *)settingNameLabel {
    if (!_settingNameLabel) {
        _settingNameLabel = [[UILabel alloc] init];
        _settingNameLabel.numberOfLines = 0;
        _settingNameLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
    }
    return _settingNameLabel;
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
    }
    return _switchButton;
}

@end
