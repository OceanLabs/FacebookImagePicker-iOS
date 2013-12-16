//
//  OLFacebookPhotosForAlbumRequest.h
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLFacebookAlbum;
@class OLFacebookPhotosForAlbumRequest;

typedef void (^OLFacebookPhotosForAlbumRequestHandler)(NSArray/*<OLFacebookImage>*/ *photos, NSError *error, OLFacebookPhotosForAlbumRequest *nextPageRequest);

@interface OLFacebookPhotosForAlbumRequest : NSObject

- (void)cancel;
- (void)getPhotosForAlbum:(OLFacebookAlbum *)album completionHandler:(OLFacebookPhotosForAlbumRequestHandler)handler;

@end
