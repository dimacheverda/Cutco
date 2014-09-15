//
//  CCStockViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockViewController.h"
#import "CCStockCollectionViewCell.h"
#import "CCStockItemViewController.h"
#import "CCStockItem.h"
#import <Parse/Parse.h>
#import <MBProgressHUD.h>

@interface CCStockViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stockItems;

@end

@implementation CCStockViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *showCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                      target:self
                                                                                      action:@selector(showCamera)];
    self.navigationItem.rightBarButtonItem = showCameraButton;
    
    [self.view addSubview:self.collectionView];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadStockItemsFromParse];
    });
}

- (void)showCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"device has no camera");
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _collectionView.frame = self.view.frame;
    _collectionView.contentInset = UIEdgeInsetsMake(64.0,
                                                    0.0,
                                                    49.0,
                                                    0.0);
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = 3.0;
        CGFloat width = (CGRectGetWidth(self.view.frame) - 2) / 3;
        layout.itemSize = CGSizeMake(width, width);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CCStockCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}

#pragma mark - Collection View DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stockItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CCStockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    CCStockItem *item = self.stockItems[indexPath.row];
    cell.title = item.name;
    cell.image = item.image;
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCStockItem *item = self.stockItems[indexPath.row];
    if (item) {
        CCStockItemViewController *stockItemVC = [[CCStockItemViewController alloc] initWithStockItem:item];
        [self.navigationController pushViewController:stockItemVC animated:YES];
    }
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"photo taken");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Parse methods

#define PARSE_CLASS_STOCK_ITEM @"Knifes"

- (void)loadStockItemsFromParse {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_STOCK_ITEM];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *items = [NSMutableArray array];
                for (id object in objects) {
                    CCStockItem *stockItem = [[CCStockItem alloc] initWithPFObject:object];
                    [items addObject:stockItem];
                }
                self.stockItems = items;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
                hud.labelText = @"Error";
                hud.removeFromSuperViewOnHide = YES;
                hud.detailsLabelText = error.description;
                [hud hide:YES afterDelay:2.0];
            });
        }
    }];
}

@end