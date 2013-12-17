//
//  OLPhotoViewController.h
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLPhotoViewController;
@class OLFacebookAlbum;

@protocol OLPhotoViewControllerDelegate <NSObject>
- (void)photoViewControllerDoneClicked:(OLPhotoViewController *)photoController;
- (void)photoViewController:(OLPhotoViewController *)photoController didFailWithError:(NSError *)error;
@end

@interface OLPhotoViewController : UIViewController

- (id)initWithAlbum:(OLFacebookAlbum *)album;

@property (nonatomic, weak) id<OLPhotoViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray/*<OLFacebookImage>*/ *selected;

@end
