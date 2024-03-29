//
//  CCStockViewController.m
//  Cutco
//
//  Created by Dima Cheverda on 9/13/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCStockViewController.h"
#import "CCStockCollectionViewCell.h"
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
#import "CCSales.h"
#import "UIColor+CCColor.h"
#import "UIFont+CCFont.h"
#import "NSDate+CCDate.h"
#import "CCPhoto.h"
#import "CCBeBack.h"

@interface CCStockViewController () <UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                        UIViewControllerTransitioningDelegate,
                                        CCCheckoutTableViewControllerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSMutableSet *checkedIndexes;
@property (strong, nonatomic) CCCheckoutToolbar *checkoutToolbar;
@property (nonatomic, getter=isCheckoutSuccessful) BOOL checkoutSuccessful;

@end

@implementation CCStockViewController

#pragma mark - View Controller LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *showEventsButton = [[UIBarButtonItem alloc] initWithTitle:@"All Events"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(showEvents)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont primaryCopyTypefaceWithSize:17] forKey:NSFontAttributeName];
    [showEventsButton setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = showEventsButton;
    self.navigationItem.title = @"";
    
    UIBarButtonItem *beBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Be back"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(beBackButtonDidPressed)];
    
    UIBarButtonItem *showCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                      target:self
                                                                                      action:@selector(showCamera)];
    if ([CCEvents sharedEvents].currentEventMember.primaryMember) {
        self.navigationItem.rightBarButtonItems = @[beBackButton, showCameraButton];
    } else {
        self.navigationItem.rightBarButtonItems = @[beBackButton];
    }
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.checkoutToolbar];
    
    if (![[CCStock sharedStock] isStockLoaded]) {
        [self loadStockItemsFromParse];
    }
    
    [[CCSales sharedSales] clearAllData];
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
        layout.itemSize = CGSizeMake(width, width);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor stockCollectionViewBackgroundColor];
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
        CGRect frame = CGRectMake(0.0,
                                  CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame),
                                  CGRectGetWidth(self.view.frame),
                                  CGRectGetHeight(self.tabBarController.tabBar.frame));
        _checkoutToolbar = [[CCCheckoutToolbar alloc] initWithFrame:frame];
        [_checkoutToolbar.checkoutButton addTarget:self
                                            action:@selector(checkoutButtonDidPressed)
                                  forControlEvents:UIControlEventTouchUpInside];
        [_checkoutToolbar.cancelButton addTarget:self
                                          action:@selector(uncheckItems)
                                forControlEvents:UIControlEventTouchUpInside];
        _checkoutToolbar.hidden = YES;
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
    cell.title = [NSString stringWithFormat:@"     $%.2f", item.salePrice];
    
    [item.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image = image;
            });
        }
    }];
    
    cell.checked = [self.checkedIndexes containsObject:indexPath];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCStockCollectionViewCell *cell = (CCStockCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setChecked:!cell.isChecked];
    
    if ([self.checkedIndexes containsObject:indexPath]) {
        [self.checkedIndexes removeObject:indexPath];
    } else {
        [self.checkedIndexes addObject:indexPath];
    }
    [self hideTabBarIfNeeded];
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Saving..";
    self.hud.detailsLabelText = @"";
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        PFFile *file = [PFFile fileWithData:UIImageJPEGRepresentation(image, 0.1)];
        CCPhoto *object = [[CCPhoto alloc] init];
        object.file = file;
        object.user = [PFUser currentUser];
        object.event = [CCEvents sharedEvents].currentEvent;
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            self.hud.mode = MBProgressHUDModeText;
            
            if (succeeded) {
                self.hud.labelText = @"Photo saved";
                self.hud.detailsLabelText = @"";
                
                [CCEvents sharedEvents].photoTakenForCurrentEvent = YES;
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

- (void)loadStockItemsFromParse {
    self.hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Loading..";
    
    PFQuery *query = [CCStockItem query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
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

#pragma mark - Action Methods

- (void)beBackButtonDidPressed {
    [self uncheckItems];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    self.hud.labelText = @"Saving..";
    self.hud.detailsLabelText = @"";
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    CCBeBack *beBack = [[CCBeBack alloc] init];
    beBack.event = [CCEvents sharedEvents].currentEvent;
    beBack.location = [CCEvents sharedEvents].currentLocation;
    beBack.user = [PFUser currentUser];
    
    [beBack saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [[CCSales sharedSales].beBacks addObject:beBack];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud show:YES];
                self.hud.labelText = @"'Be back' saved";
                self.hud.detailsLabelText = @"";
                self.hud.mode = MBProgressHUDModeText;
                [self.hud hide:YES afterDelay:1.0];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud show:YES];
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = error.description;
                self.hud.mode = MBProgressHUDModeText;
                [self.hud hide:YES afterDelay:2.0];
            });
        }
    }];    
}

- (void)showEvents {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.collectionView = nil;
}

#pragma mark - Checkout methods

- (void)hideTabBarIfNeeded {
    if (self.checkedIndexes.count > 0) {
        self.tabBarController.tabBar.hidden = YES;
        self.checkoutToolbar.hidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = NO;
        self.checkoutToolbar.hidden = YES;
    }
}

- (void)uncheckItems {
    for (NSIndexPath *indexPath in self.checkedIndexes) {
        CCStockCollectionViewCell *cell = (CCStockCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setChecked:NO];
    }
    [self.checkedIndexes removeAllObjects];
    self.tabBarController.tabBar.hidden = NO;
    self.checkoutToolbar.hidden = YES;
}

- (void)checkoutButtonDidPressed {
    if ([CCEvents sharedEvents].isPhotoTakenForCurrentEvent) {
        [self performCheckoutTransition];
    } else {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Checking photo..";
        self.hud.detailsLabelText = @"";
        
        PFQuery *query = [CCPhoto query];
        [query clearCachedResult];
        [query whereKey:@"event" equalTo:[CCEvents sharedEvents].currentEvent];
        [query whereKey:@"createdAt" lessThanOrEqualTo:[NSDate endOfDay]];
        [query whereKey:@"createdAt" greaterThanOrEqualTo:[NSDate beginningOfDay]];

        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                NSLog(@"photos number : %d", number);
                if (number > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [CCEvents sharedEvents].photoTakenForCurrentEvent = YES;
                        
                        [self.hud hide:YES];
                        
                        [self performCheckoutTransition];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.hud.mode = MBProgressHUDModeText;
                        self.hud.labelText = @"You haven't submitted a photo yet";
                        self.hud.detailsLabelText = @"Please do";
                        [self.hud hide:YES afterDelay:2.0];
                    });
                }
            } else {
                NSLog(@"error %@", error);
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Error";
                self.hud.detailsLabelText = [NSString stringWithFormat:@"%@", error.description];
                [self.hud hide:YES afterDelay:2.0];
            }
        }];
    }
}

- (void)performCheckoutTransition {
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
    checkoutVC.delegate = self;
    [self presentViewController:checkoutVC animated:YES completion:nil];
}

#pragma mark - Checkout View Contorller Delegate

- (void)checkoutWillDismissWithSuccess:(BOOL)success {
    [self uncheckItems];
    self.checkoutSuccessful = success;
}

#pragma mark - Transitioning Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    CCPopoverTransition *popoverTransition = [[CCPopoverTransition alloc] init];
    return popoverTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    CCPopoverDismissal *popoverDismissal = [[CCPopoverDismissal alloc] initWithCheckoutSuccess:self.isCheckoutSuccessful];
    return popoverDismissal;
}

@end