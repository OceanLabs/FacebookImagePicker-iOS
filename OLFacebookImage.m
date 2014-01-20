//
//  OLFacebookImage.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookImage.h"

static NSString *const kKeyThumbURL = @"co.oceanlabs.FacebookImagePicker.kKeyThumbURL";
static NSString *const kKeyFullURL = @"co.oceanlabs.FacebookImagePicker.kKeyFullURL";
static NSString *const kKeyAlbumId = @"co.oceanlabs.FacebookImagePicker.kKeyAlbumId";

@implementation OLFacebookImage
- (id)initWithThumbURL:(NSURL *)thumbURL fullURL:(NSURL *)fullURL albumId:(NSString *)albumId {
    if (self = [super init]) {
        _thumbURL = thumbURL;
        _fullURL = fullURL;
        _albumId = albumId;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[OLFacebookImage class]]) {
        return NO;
    }
    
    return [self.thumbURL isEqual:[object thumbURL]] && [self.fullURL isEqual:[object fullURL]] && [self.albumId isEqualToString:[object albumId]];
}

- (NSUInteger)hash {
    return 37 * (37 * self.thumbURL.hash + self.fullURL.hash) + self.albumId.hash;
}

#pragma mark - NSCoding protocol methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.thumbURL forKey:kKeyThumbURL];
    [aCoder encodeObject:self.fullURL forKey:kKeyFullURL];
    [aCoder encodeObject:self.albumId forKey:kKeyAlbumId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _thumbURL = [aDecoder decodeObjectForKey:kKeyThumbURL];
        _fullURL = [aDecoder decodeObjectForKey:kKeyFullURL];
        _albumId = [aDecoder decodeObjectForKey:kKeyAlbumId];
    }
    
    return self;
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone {
    OLFacebookImage *copy = [[OLFacebookImage allocWithZone:zone] initWithThumbURL:self.thumbURL fullURL:self.fullURL albumId:self.albumId];
    return copy;
}

@end
