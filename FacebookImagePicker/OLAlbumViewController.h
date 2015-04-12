//
//  OLAlbumViewController.h
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLAlbumViewController;

@protocol OLAlbumViewControllerDelegate <NSObject>
- (void)albumViewControllerDoneClicked:(OLAlbumViewController *)albumController;
- (void)albumViewController:(OLAlbumViewController *)albumController didFailWithError:(NSError *)error;
@end

@interface OLAlbumViewController : UIViewController
@property (nonatomic, weak) id<OLAlbumViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray/*<OLFacebookImage>*/ *selected;
@end
