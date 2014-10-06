//
//  CCCheckoutTableViewCell.h
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCheckoutTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIButton *minusButton;
@property (strong, nonatomic) UIButton *plusButton;
@property (strong, nonatomic) UILabel *quantityLabel;

@end
