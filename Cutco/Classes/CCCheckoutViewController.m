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

@interface CCCheckoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CCCheckoutTableView *tableView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CCCheckoutViewController

#pragma mark - Init

- (instancetype)initWithStockItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = [NSArray arrayWithArray:items];
    }
    return self;
}

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.tableView];
}

#pragma mark - Accessors

#define VIEW_WIDTH self.view.frame.size.width-40.0
#define VIEW_HEIGHT self.view.frame.size.height-160.0
#define BUTTON_HEIGHT 44.0

- (CCCheckoutTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CCCheckoutTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEW_WIDTH, VIEW_HEIGHT - BUTTON_HEIGHT) style:UITableViewStylePlain];
        [_tableView registerClass:[CCCheckoutTableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _cancelButton.backgroundColor = [UIColor colorWithRed:0.83 green:0.33 blue:0 alpha:1];
        _cancelButton.frame = CGRectMake(0.0,
                                         (VIEW_HEIGHT) - BUTTON_HEIGHT,
                                         (VIEW_WIDTH)/2.0,
                                         BUTTON_HEIGHT);
        [_cancelButton addTarget:self action:@selector(cancelButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.44 alpha:1];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _confirmButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                          (VIEW_HEIGHT) - BUTTON_HEIGHT,
                                          (VIEW_WIDTH)/2.0,
                                          BUTTON_HEIGHT);
        [_confirmButton addTarget:self action:@selector(confirmButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCCheckoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell.plusButton addTarget:self action:@selector(quantityButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusButton addTarget:self action:@selector(quantityButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];

    CCStockItem *item = self.items[indexPath.row];
    [item.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image = image;
            });
        }
    }];
    return cell;
}

#pragma mark - Action Handlers

- (void)quantityButtonDidPressed:(UIButton *)sender {
    CCCheckoutTableViewCell *cell = (CCCheckoutTableViewCell *)[[sender superview] superview];
    NSInteger currentQuantity = [cell.quantityLabel.text integerValue];
    if ([sender.titleLabel.text isEqualToString:@"-"]) {
        currentQuantity--;
    } else if ([sender.titleLabel.text isEqualToString:@"+"]) {
        currentQuantity++;
    }
    if (currentQuantity == 0) {
        currentQuantity = 1;
    }
    cell.quantityLabel.text = [NSString stringWithFormat:@"%d", (int)currentQuantity];
}

- (void)cancelButtonDidPressed {
    [self.delegate checkoutWillDismissWithSuccess:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonDidPressed {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Loading..";
    
    NSUInteger row = 0;
    NSMutableArray *itemsForSale = [NSMutableArray array];
    for (CCStockItem *item in self.items) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        CCCheckoutTableViewCell *cell = (CCCheckoutTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger quantity = [cell.quantityLabel.text integerValue];
        for (int i = 0; i < quantity; i++) {
            [itemsForSale addObject:item];
        }
        row++;
    }
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
