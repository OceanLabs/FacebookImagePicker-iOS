//
//  FacebookImagePickerController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookImagePickerController.h"
#import "OLAlbumViewController.h"
#import <FBSDKLoginKit.h>
#import <FBSDKCoreKit.h>

@interface OLFacebookImagePickerController () <OLAlbumViewControllerDelegate>
@property (nonatomic, strong) OLAlbumViewController *albumVC;
@end

@implementation OLFacebookImagePickerController

@dynamic delegate;

- (id)init {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    if (self = [super initWithRootViewController:vc]) {
        
    }
    
    return self;
}

- (void)cancelButtonClicked{
    [self.delegate facebookImagePicker:self didFinishPickingImages:@[]];
}

- (void)viewDidAppear:(BOOL)animated{
    if (![FBSDKAccessToken currentAccessToken]){
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile"] fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 [self.delegate facebookImagePicker:self didFailWithError:error];
             } else if (result.isCancelled) {
                [self.delegate facebookImagePicker:self didFinishPickingImages:@[]];
             } else {
                 OLAlbumViewController *albumController = [[OLAlbumViewController alloc] init];
                 self.albumVC = albumController;
                 self.albumVC.delegate = self;
                 self.viewControllers = @[albumController];
             }
         }];
    }
}

- (void)setSelected:(NSArray *)selected {
    self.albumVC.selected = selected;
}

- (NSArray *)selected {
    return self.albumVC.selected;
}

#pragma mark - OLAlbumViewControllerDelegate methods

- (void)albumViewControllerDoneClicked:(OLAlbumViewController *)albumController {
    [self.delegate facebookImagePicker:self didFinishPickingImages:albumController.selected];
}

- (void)albumViewController:(OLAlbumViewController *)albumController didFailWithError:(NSError *)error {
    [self.delegate facebookImagePicker:self didFailWithError:error];
}

@end
