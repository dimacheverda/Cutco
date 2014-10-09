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
#import "CCCheckoutToolbar.h"
#import "CCCheckoutViewController.h"
#import "CCPopoverTransition.h"
#import "CCPopoverDismissal.h"
#import "CCEvents.h"
#import "CCEvent.h"

@interface CCStockViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSMutableSet *checkedIndexes;
@property (strong, nonatomic) CCCheckoutToolbar *checkoutToolbar;
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

@end

@implementation CCStockViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *showEventsButton = [[UIBarButtonItem alloc] initWithTitle:@"All Events"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(showEvents)];
    self.navigationItem.leftBarButtonItem = showEventsButton;
    
    // only for primary member
    if ([CCEvents sharedEvents].currentEventMember.primaryMember) {
        UIBarButtonItem *showCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                          target:self
                                                                                          action:@selector(showCamera)];
        self.navigationItem.rightBarButtonItem = showCameraButton;
    }
    
    [self.view addSubview:self.collectionView];

    self.tabBarHidden = NO;
    if (![[CCStock sharedStock] isStockLoaded]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadStockItemsFromParse];
        });
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

- (NSMutableSet *)checkedIndexes {
    if (!_checkedIndexes) {
        _checkedIndexes = [[NSMutableSet alloc] init];
    }
    return _checkedIndexes;
}

- (CCCheckoutToolbar *)checkoutToolbar {
    if (!_checkoutToolbar) {
        _checkoutToolbar = [[CCCheckoutToolbar alloc] init];
        CGRect frame = CGRectMake(0.0,
                                  CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame),
                                  CGRectGetWidth(self.view.frame),
                                  CGRectGetHeight(self.tabBarController.tabBar.frame));
        _checkoutToolbar.frame = frame;
        [_checkoutToolbar.cancelButton setAction:@selector(uncheckItems)];
        _checkoutToolbar.checkoutButton.target = self;
        _checkoutToolbar.checkoutButton.action = @selector(checkoutButtonDidPressed);
    }
    return _checkoutToolbar;
}

#pragma mark - Collection View DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [CCStock sharedStock].items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CCStockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    CCStockItem *item = [CCStock sharedStock].items[indexPath.row];
    cell.title = item.name;
    [item.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image = image;
            });
        }
    }];
    cell.checkMark.checked = [self.checkedIndexes containsObject:indexPath];
 
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCStockCollectionViewCell *cell = (CCStockCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.checkMark.checked = !cell.checkMark.checked;

    if ([self.checkedIndexes containsObject:indexPath]) {
        [self.checkedIndexes removeObject:indexPath];
    } else {
        [self.checkedIndexes addObject:indexPath];
    }
//    NSLog(@"checked indexes %@", self.checkedIndexes);
    [self hideTabBarIfNeeded];
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

- (void)showEvents {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.collectionView = nil;
}

#pragma mark - Parse methods

- (void)loadStockItemsFromParse {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Loading..";
    
    PFQuery *query = [CCStockItem query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                NSMutableArray *items = [NSMutableArray array];
                for (CCStockItem *object in objects) {
                    [items addObject:object];
                }
                [CCStock sharedStock].items = objects;
                [CCStock sharedStock].isStockLoaded = YES;
                
                // update UI
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

#pragma mark - Checkout methods

- (void)hideTabBarIfNeeded {
    if (self.checkedIndexes.count > 0 && !self.isTabBarHidden) {
        self.tabBarController.tabBar.hidden = YES;
        [self.view addSubview:self.checkoutToolbar];
    } else {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)uncheckItems {
    for (NSIndexPath *indexPath in self.checkedIndexes) {
        CCStockCollectionViewCell *cell = (CCStockCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.checkMark.checked = NO;
    }
    [self.checkedIndexes removeAllObjects];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)checkoutButtonDidPressed {
    NSArray *checkedIndexesArray = [self.checkedIndexes allObjects];
    checkedIndexesArray = [checkedIndexesArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger r1 = [obj1 row];
        NSInteger r2 = [obj2 row];
        if (r1 > r2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (r1 < r2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    NSMutableArray *items = [NSMutableArray array];
    for (NSIndexPath *indexPath in checkedIndexesArray) {
        [items addObject:[CCStock sharedStock].items[indexPath.row]];
    }
    
    CCCheckoutViewController *checkoutVC = [[CCCheckoutViewController alloc] initWithStockItems:items];
    checkoutVC.modalPresentationStyle = UIModalPresentationCustom;
    checkoutVC.transitioningDelegate = self;
    [self presentViewController:checkoutVC animated:YES completion:^{
    }];
}

#pragma mark - Transitioning Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    CCPopoverTransition *popoverTransition = [[CCPopoverTransition alloc] init];
    return popoverTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    CCPopoverDismissal *popoverDismissal = [[CCPopoverDismissal alloc] init];
    return popoverDismissal;
}

@end