//
//  OLAlbumViewController.h
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLAlbumViewController;
@class OLFacebookImage;

@protocol OLAlbumViewControllerDelegate <NSObject>
- (void)albumViewControllerDoneClicked:(OLAlbumViewController *)albumController;
- (void)albumViewController:(OLAlbumViewController *)albumController didFailWithError:(NSError *)error;
@optional
- (void)albumViewController:(OLAlbumViewController *)albumController didSelectImage:(OLFacebookImage *)image;
- (BOOL)albumViewController:(OLAlbumViewController *)albumController shouldSelectImage:(OLFacebookImage *)image;
@end

@interface OLAlbumViewController : UIViewController
@property (nonatomic, weak) id<OLAlbumViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray/*<OLFacebookImage>*/ *selected;
@property (nonatomic, assign) BOOL shouldDisplayLogoutButton;
@end
