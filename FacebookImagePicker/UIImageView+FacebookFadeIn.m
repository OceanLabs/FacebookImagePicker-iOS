//
//  UIImageView+FacebookFadeIn.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 23/03/2015.
//  Copyright (c) 2015 Deon Botha. All rights reserved.
//

#import "UIImageView+FacebookFadeIn.h"
#import "OLFacebookImageDownloader.h"

@implementation UIImageView (FacebookFadeIn)
- (void)setAndFadeInFacebookImageWithURL:(NSURL *)url {
    [self setAndFadeInFacebookImageWithURL:url placeholder:nil];
}

-(void)setAndFadeInFacebookImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    self.alpha = 0;
    
    [[OLFacebookImageDownloader sharedInstance] downloadImageAtURL:url withCompletionHandler:^(UIImage *image, NSError *error){
        self.image = image;
        [UIView beginAnimations:@"fadeIn" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        self.alpha = 1;
        [UIView commitAnimations];
        
    }];
    
}
@end

