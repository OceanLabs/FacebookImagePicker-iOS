//
//  OLFacebookImage.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookImage.h"

@implementation OLFacebookImage
- (id)initWithThumbURL:(NSURL *)thumbURL fullURL:(NSURL *)fullURL {
    if (self = [super init]) {
        _thumbURL = thumbURL;
        _fullURL = fullURL;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[OLFacebookImage class]]) {
        return NO;
    }
    
    return [self.thumbURL isEqual:[object thumbURL]] && [self.fullURL isEqual:[object fullURL]];
}

- (NSUInteger)hash {
    return self.thumbURL.hash + self.fullURL.hash;
}

@end
