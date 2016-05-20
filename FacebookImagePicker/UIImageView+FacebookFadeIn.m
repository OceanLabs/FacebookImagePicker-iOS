//
//  UIImageView+FacebookFadeIn.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 23/03/2015.
//  Copyright (c) 2015 Deon Botha. All rights reserved.
//

#import "UIImageView+FacebookFadeIn.h"
#import "OLFacebookImageDownloader.h"
#import "objc/runtime.h"

static char tasksKey;

@implementation UIImageView (FacebookFadeIn)
- (void)setAndFadeInFacebookImageWithURL:(NSURL *)url {
    [self setAndFadeInFacebookImageWithURL:url placeholder:nil];
}

-(void)setAndFadeInFacebookImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    for (id key in self.tasks.allKeys){
        if (![key isEqual:url]){
            [self.tasks[key] cancel];
        }
    }
    
    self.alpha = 0;
    NSURLSessionTask *task = [[OLFacebookImageDownloader sharedInstance] downloadImageAtURL:url withCompletionHandler:^(UIImage *image, NSError *error){
        if ([self.tasks[url] state] == NSURLSessionTaskStateCanceling){
            return;
        }
        self.image = image;
        [UIView beginAnimations:@"fadeIn" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        self.alpha = 1;
        [UIView commitAnimations];
        
    }];
    self.tasks[url] = task;
}

- (NSMutableDictionary *)tasks{
    NSMutableDictionary *tasks = objc_getAssociatedObject(self, &tasksKey);
    if (tasks){
        return tasks;
    }
    tasks = [[NSMutableDictionary alloc] init];
    objc_setAssociatedObject(self, &tasksKey, tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tasks;
}

@end

