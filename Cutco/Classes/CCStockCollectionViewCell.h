//
//  CCStockCollectionViewCell.h
//  Cutco
//
//  Created by Dima Cheverda on 9/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCheckMark.h"

@interface CCStockCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, getter=isChecked) BOOL checked;
@property (strong, nonatomic) CCCheckMark *checkMark;

@end
