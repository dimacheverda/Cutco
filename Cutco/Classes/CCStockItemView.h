//
//  CCStockItemView.h
//  Cutco
//
//  Created by Dima Cheverda on 9/18/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCStockItemView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *retailPriceLabel;
@property (strong, nonatomic) UILabel *salePriceLabel;
@property (strong, nonatomic) UILabel *UPCLabel;

@end
