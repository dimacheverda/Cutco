//
//  CCStockItemViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/14/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockItemViewController.h"
#import <Parse/Parse.h>
#import "CCSale.h"
#import <MBProgressHUD.h>
#import "NSDate+CCDate.h"
#import "CCStockItemView.h"
#import "CCSales.h"

@interface CCStockItemViewController ()

@property (strong, nonatomic) CCStockItem *stockItem;
@property (strong, nonatomic) CCStockItemView *stockItemView;
//@property (strong, nonatomic) UIImageView *imageView;
//@property (strong, nonatomic) UILabel *nameLabel;
//@property (strong, nonatomic) UILabel *descriptionLabel;
//@property (strong, nonatomic) UILabel *retailPriceLabel;
//@property (strong, nonatomic) UILabel *salePriceLabel;
//@property (strong, nonatomic) UILabel *UPCLabel;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CCStockItemViewController

#pragma mark - Init

- (instancetype)initWithStockItem:(CCStockItem *)stockItem {
    self = [super init];
    if (self) {
        _stockItem = stockItem;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveSaleButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Sale"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(saveSaleButtonDidPressed)];
    self.navigationItem.rightBarButtonItem = saveSaleButton;
    
    self.stockItemView = [[CCStockItemView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.stockItemView];
    
//    self.stockItemView.imageView.image = self.stockItem.image;
    self.stockItemView.nameLabel.text = self.stockItem.name;
    self.stockItemView.descriptionLabel.text = self.stockItem.description;
    self.stockItemView.retailPriceLabel.text = [NSString stringWithFormat:@"$%d", (int)self.stockItem.retailPrice];
    self.stockItemView.salePriceLabel.text = [NSString stringWithFormat:@"$%d", (int)self.stockItem.salePrice];
    self.stockItemView.UPCLabel.text = [NSString stringWithFormat:@"$%d", (int)self.stockItem.UPC];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat textOffset = 20.0;
    CGRect rect;
    
    self.stockItemView.imageView.frame = CGRectMake(8.0,
                                  8.0 + 64.0,
                                  CGRectGetWidth(self.view.frame) - 16.0,
                                  CGRectGetWidth(self.view.frame) / 4 * 3 - 12.0);
    
    rect = [self calculateFrameForText:self.stockItemView.nameLabel.text font:self.stockItemView.nameLabel.font];
    self.stockItemView.nameLabel.frame = CGRectMake(textOffset,
                                  CGRectGetMaxY(self.stockItemView.imageView.frame) + 8.0,
                                  CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                  CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:self.stockItemView.descriptionLabel.text font:self.stockItemView.descriptionLabel.font];
    self.stockItemView.descriptionLabel.frame = CGRectMake(textOffset,
                                         CGRectGetMaxY(self.stockItemView.nameLabel.frame) + 8.0,
                                         CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                         CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:self.stockItemView.retailPriceLabel.text font:self.stockItemView.retailPriceLabel.font];
    self.stockItemView.retailPriceLabel.frame = CGRectMake(textOffset,
                                         CGRectGetMaxY(self.stockItemView.descriptionLabel.frame) + 8.0,
                                         CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                         CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:self.stockItemView.salePriceLabel.text font:self.stockItemView.salePriceLabel.font];
    self.stockItemView.salePriceLabel.frame = CGRectMake(textOffset,
                                       CGRectGetMaxY(self.stockItemView.retailPriceLabel.frame) + 8.0,
                                       CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                       CGRectGetHeight(rect));
    
    rect = [self calculateFrameForText:self.stockItemView.UPCLabel.text font:self.stockItemView.UPCLabel.font];
    self.stockItemView.UPCLabel.frame = CGRectMake(textOffset,
                                     CGRectGetMaxY(self.stockItemView.salePriceLabel.frame) + 8.0,
                                     CGRectGetWidth(self.view.frame) - 2 * textOffset,
                                     CGRectGetHeight(rect));
}

#pragma mark - Label Calculations

- (CGRect)calculateFrameForText:(NSString *)text font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 20 * 2, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect;
}

#pragma mark - Action Handlers

- (void)saveSaleButtonDidPressed {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading";
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    if ([[self lastPhotoDate] isCurrentDay]) {
        [self saveSaleToParse];
    } else {
        [self loadLastPhotoDateFromParseAndSaveSale];
    }
}

- (NSDate *)lastPhotoDate {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"lastPhotoDate"];
}

- (void)loadLastPhotoDateFromParseAndSaveSale {
    PFQuery *quary = [PFQuery queryWithClassName:@"Photo"];
    [quary whereKey:@"user" equalTo:[PFUser currentUser]];
    [quary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            BOOL isDateFound = NO;
            for (int i = (int)objects.count - 1; i >= 0; i--) {
                PFObject *object = objects[i];
                
                if ([object.createdAt isCurrentDay]) {
                    i = -1;
                    isDateFound = YES;
                    [[NSUserDefaults standardUserDefaults] setValue:object.createdAt forKey:@"lastPhotoDate"];
                    [self saveSaleToParse];
                }
            }
            if (!isDateFound) {
                // no booth photo for current day found
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Wait!";
                self.hud.detailsLabelText = @"No booth photo found for today. Take photo first to make sales.";
                [self.hud hide:YES afterDelay:3.0];
            }
        } else {
            // can't load booth photos data
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Error";
            self.hud.detailsLabelText = error.localizedDescription;
            [self.hud hide:YES afterDelay:2.0];
        }
    }];
}

- (void)saveSaleToParse {
    CCSale *sale = [[CCSale alloc] initWithStockItem:self.stockItem];
    
    [sale saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[CCSales sharedSales] addSale:sale];
            
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Success";
            [self.hud hide:YES afterDelay:1.0];
            
            // pop VC after 1 sec
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Error";
            self.hud.detailsLabelText = error.localizedDescription;
            [self.hud hide:YES afterDelay:2.0];
        }
    }];
}

@end