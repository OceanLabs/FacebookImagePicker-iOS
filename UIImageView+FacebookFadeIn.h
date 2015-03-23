//
//  UIImageView+FacebookFadeIn.h
//  FacebookImagePicker
//
//  Created by Deon Botha on 23/03/2015.
//  Copyright (c) 2015 Deon Botha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (FacebookFadeIn)
- (void)setAndFadeInFacebookImageWithURL:(NSURL *)url;
- (void)setAndFadeInFacebookImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder;
@end
