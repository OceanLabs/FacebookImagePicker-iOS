//
//  OLFacebookImage.h
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The OLFacebookImage class provides a simple model object representation of an Facebook album photo.
 */
@interface OLFacebookImage : NSObject

/**
 Initialises a new OLFacebookImage object instance.
 
 @param thumbURL The URL to access the thumbnail image
 @param fullURL The URL to access the standard resolution image
 @return Returns an initialised OLFacebookImage instance
 */
- (id)initWithThumbURL:(NSURL *)thumbURL fullURL:(NSURL *)fullURL;

/**
 The URL to access the thumb resolution image
 */
@property (nonatomic, readonly) NSURL *thumbURL;

/**
 The URL to access the standard resolution image
 */
@property (nonatomic, readonly) NSURL *fullURL;

@end
