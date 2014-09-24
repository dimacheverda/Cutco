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
#import "CCStock.h"

@interface CCStockViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stockItems;
@property (strong, nonatomic) MBProgressHUD *hud;

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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadStockItemsFromParse];
    });
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
        layout.minimumLineSpacing = 1.0;
        CGFloat width = (CGRectGetWidth(self.view.frame) - 2) / 3;
        layout.itemSize = CGSizeMake(width, width / 5 * 6);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.hud show:YES];
    self.hud.labelText = @"Saving..";
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        PFFile *file = [PFFile fileWithData:UIImageJPEGRepresentation(image, 0.1)];
        PFObject *object = [PFObject objectWithClassName:@"Photo"];
        object[@"photo"] = file;
        object[@"user"] = [PFUser currentUser];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.hud.mode = MBProgressHUDModeText;
            if (succeeded) {
                self.hud.labelText = @"Photo saved";
                [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"lastPhotoDate"];
            } else {
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = [NSString stringWithFormat:@"Error : %@", error];
                NSLog(@"photo not saved %@", error);
            }
            [self.hud hide:YES afterDelay:1.0f];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"No camera";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - Parse methods

#define PARSE_CLASS_STOCK_ITEM @"StockItem"

- (void)loadStockItemsFromParse {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Loading..";
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_STOCK_ITEM];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *items = [NSMutableArray array];
                for (id object in objects) {
                    CCStockItem *stockItem = [[CCStockItem alloc] initWithPFObject:object];
                    [items addObject:stockItem];
                }
                self.stockItems = items;
                [CCStock sharedStock].items = items;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [self.hud hide:YES];
                });
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