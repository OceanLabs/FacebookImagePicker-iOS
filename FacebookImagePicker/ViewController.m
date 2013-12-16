//
//  ViewController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK.h>
#import "OLFacebookAlbumRequest.h"
#import "OLFacebookPhotosForAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import "OLFacebookImage.h"
#import "OLFacebookImagePickerController.h"

@interface ViewController () <UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate>
@property (nonatomic, strong) OLFacebookAlbumRequest *albumRequest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    OLFacebookAlbumRequest *req = [[OLFacebookAlbumRequest alloc] init];
    [req getAlbums:^(NSArray *albums, NSError *error, OLFacebookAlbumRequest *nextPageRequest) {
        OLFacebookPhotosForAlbumRequest *photosForAlbumReq = [[OLFacebookPhotosForAlbumRequest alloc] init];
        [photosForAlbumReq getPhotosForAlbum:albums.lastObject completionHandler:^(NSArray/*<OLFacebookImage>*/ *photos, NSError *error, OLFacebookPhotosForAlbumRequest *nextPageRequest) {
            for (OLFacebookImage *facebookImage in photos) {
                NSLog(@"thumb: %@", facebookImage.thumbURL);
            }
        }];
    }];
}

- (IBAction)onButtonFacebookImagePickerClicked:(id)sender {
    OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
    picker.delegate = self;
   [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - OLFacebookImagePickerControllerDelegate methods

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray/*<OLFacebookImage>*/ *)images {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
