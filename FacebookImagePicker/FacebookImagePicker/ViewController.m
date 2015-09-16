//
//  ViewController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "ViewController.h"
#import "OLFacebookAlbumRequest.h"
#import "OLFacebookPhotosForAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import "OLFacebookImage.h"
#import "OLFacebookImagePickerController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController () <UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate>
@property (nonatomic, strong) OLFacebookAlbumRequest *albumRequest;
@property (nonatomic, strong) NSArray *selected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile",  @"user_photos"];
    CGRect f = loginButton.frame;
    f.origin.x = (self.view.frame.size.width - f.size.width) / 2;
    f.origin.y = (self.view.frame.size.height - f.size.height) / 2;
    loginButton.frame = f;
    [self.view addSubview:loginButton];
}

- (IBAction)onButtonFacebookImagePickerClicked:(id)sender {
    OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
    picker.selected = self.selected;
    picker.delegate = self;
   [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - OLFacebookImagePickerControllerDelegate methods

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^() {
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray/*<OLFacebookImage>*/ *)images {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.selected = images;
    NSLog(@"User did pick %lu images", (unsigned long) images.count);
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"User cancelled facebook image picking");
}


@end
