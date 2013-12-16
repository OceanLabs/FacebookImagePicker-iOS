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
@end

@interface OLAlbumViewController : UITableViewController
@property (nonatomic, weak) id<OLAlbumViewControllerDelegate> delegate;
@end
