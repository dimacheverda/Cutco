//
//  CCCheckoutViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 10/6/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCCheckoutViewController.h"
#import "CCCheckoutTableView.h"
#import "CCCheckoutTableViewCell.h"
#import "CCStockItem.h"
#import "CCStock.h"
#import "CCSale.h"
#import "CCSales.h"
#import <MBProgressHUD.h>
#import "CCStockViewController.h"
#import "UIColor+CCColor.h"
#import "UIFont+CCFont.h"

@interface CCCheckoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CCCheckoutTableView *tableView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSMutableArray *quantity;
@property (strong, nonatomic) UISwitch *switchToggle;
@property (strong, nonatomic) UILabel *switchLabel;

@end

@implementation CCCheckoutViewController

#pragma mark - Init

- (instancetype)initWithStockItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = [NSArray arrayWithArray:items];
        
        self.quantity = [[NSMutableArray alloc] init];
        for (int i = 0; i < items.count; i++) {
            [self.quantity addObject:[NSNumber numberWithInteger:1]];
        }
    }
    return self;
}

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor checkoutViewBackgroundColor];
    
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.switchToggle];
    [self.view addSubview:self.switchLabel];
}

#define kBottomButtonsHeight 44.0

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _switchLabel.frame = CGRectMake(16.0,
                                    0.0,
                                    CGRectGetWidth(self.view.frame),
                                    kBottomButtonsHeight);
    
    _switchToggle.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60.0,
                                     0.0,
                                     64.0,
                                     kBottomButtonsHeight);
    _switchToggle.center = CGPointMake(CGRectGetMidX(_switchToggle.frame),
                                       kBottomButtonsHeight / 2.0);
    
    _tableView.frame = CGRectMake(0.0,
                                  kBottomButtonsHeight,
                                  CGRectGetWidth(self.view.frame),
                                  CGRectGetHeight(self.view.frame) - kBottomButtonsHeight * 2);
    
    _cancelButton.frame = CGRectMake(0.0,
                                     CGRectGetHeight(self.view.frame) - kBottomButtonsHeight,
                                     CGRectGetWidth(self.view.frame) / 3.0,
                                     kBottomButtonsHeight);
    

    _confirmButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                      (CGRectGetHeight(self.view.frame)) - kBottomButtonsHeight,
                                      CGRectGetWidth(self.view.frame) / 3.0 * 2.0,
                                      kBottomButtonsHeight);
}

#pragma mark - Accessors

- (CCCheckoutTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CCCheckoutTableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        [_tableView registerClass:[CCCheckoutTableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setImage:[UIImage imageNamed:@"x-mark"] forState:UIControlStateNormal];
        _cancelButton.contentMode = UIViewContentModeCenter;
        _cancelButton.tintColor = [UIColor whiteColor];
        _cancelButton.backgroundColor = [UIColor checkoutCancelColor];
        [_cancelButton addTarget:self
                          action:@selector(cancelButtonDidPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor checkoutConfirmColor];
        _confirmButton.titleLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
        [_confirmButton addTarget:self
                           action:@selector(confirmButtonDidPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UILabel *)switchLabel {
    if (!_switchLabel) {
        _switchLabel = [[UILabel alloc] init];
        _switchLabel.numberOfLines = 0;
        _switchLabel.text = @"New customer";
        _switchLabel.font = [UIFont primaryCopyTypefaceWithSize:20.0];
    }
    return _switchLabel;
}

- (UISwitch *)switchToggle {
    if (!_switchToggle) {
        _switchToggle = [[UISwitch alloc] init];
    }
    return _switchToggle;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(self.view.frame) / 3.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCCheckoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell.plusButton addTarget:self
                        action:@selector(quantityButtonDidPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [cell.minusButton addTarget:self
                         action:@selector(quantityButtonDidPressed:)
               forControlEvents:UIControlEventTouchUpInside];

    CCStockItem *item = self.items[indexPath.row];
    [item.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image = image;
            });
        }
    }];
    
    cell.quantityLabel.text = [NSString stringWithFormat:@"%@", self.quantity[indexPath.row]];
    
    return cell;
}

#pragma mark - Action Handlers

- (void)quantityButtonDidPressed:(UIButton *)sender {
    CCCheckoutTableViewCell *cell = (CCCheckoutTableViewCell *)[[sender superview] superview];
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    
    NSNumber *currentQuantity = self.quantity[index];
    NSInteger quantity = [currentQuantity integerValue];

    if (sender.tag == 0) {
        quantity--;
    } else if (sender.tag == 1) {
        quantity++;
    }
    if (quantity == 0) {
        quantity = 1;
    }
    
    currentQuantity = [NSNumber numberWithInteger:quantity];
    self.quantity[index] = currentQuantity;
    
    cell.quantityLabel.text = [NSString stringWithFormat:@"%@", self.quantity[index]];
}

- (void)cancelButtonDidPressed {
    [self.delegate checkoutWillDismissWithSuccess:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonDidPressed {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Saving..";
    
    NSMutableArray *itemsForSale = [NSMutableArray array];
    
    for (int itemIndex = 0; itemIndex < self.items.count; itemIndex++) {
        NSInteger quantity = [self.quantity[itemIndex] integerValue];
        for (int i = 1; i <= quantity; i++) {
            [itemsForSale addObject:self.items[itemIndex]];
        }
    }

    NSLog(@"items for sale: %d", (int)itemsForSale.count);
    
    [self saveSalesToParse:itemsForSale];
}

- (void)saveSalesToParse:(NSArray *)items {
    NSMutableArray *sales = [NSMutableArray array];
    for (CCStockItem *item in items) {
        CCSale *sale = [[CCSale alloc] initWithStockItem:item];
        [sales addObject:sale];
    }
    
    [PFObject saveAllInBackground:sales block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            for (CCSale *sale in sales) {
                [[CCSales sharedSales] addSale:sale];
            }
    
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [self.delegate checkoutWillDismissWithSuccess:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.description;
                [self.hud hide:YES afterDelay:2.0];
            });
        }
    }];
}

@end
