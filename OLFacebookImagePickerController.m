//
//  FacebookImagePickerController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookImagePickerController.h"
#import "OLAlbumViewController.h"

@interface OLFacebookImagePickerController () <OLAlbumViewControllerDelegate>

@end

@implementation OLFacebookImagePickerController

- (id)init {
    
    OLAlbumViewController *albumController = [[OLAlbumViewController alloc] init];
    if (self = [super initWithRootViewController:albumController]) {
        albumController.delegate = self;
    }
    
    return self;
}

#pragma mark - OLAlbumViewControllerDelegate methods

- (void)albumViewControllerDoneClicked:(OLAlbumViewController *)albumController {
    [self.delegate facebookImagePickerDidCancelPickingImages:self];
}

@end
