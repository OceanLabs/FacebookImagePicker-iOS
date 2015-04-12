//
//  ImagePickerCell.h
//  Ps
//
//  Created by Deon Botha on 10/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLFacebookImage;

@interface OLFacebookImagePickerCell : UICollectionViewCell
- (void)bind:(OLFacebookImage *)media;

@end
