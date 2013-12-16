//
//  OLFacebookAlbumRequest.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookAlbumRequest.h"
#import "OLFacebookImagePickerConstants.h"
#import "OLFacebookAlbum.h"
#import <FacebookSDK.h>

@interface OLFacebookAlbumRequest ()
@property (nonatomic, assign) BOOL cancelled;
@end

@implementation OLFacebookAlbumRequest

+ (void)handleFacebookError:(NSError *)error completionHandler:(OLFacebookAlbumRequestHandler)handler {
    NSString *message;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        message = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        message = @"Your current Facebook session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        message = @"The app requires authorization to access your Facebook photos to continue. Please open Settings and provide access.";
    } else {
        message = @"Failed to access your Facebook photos. Please check your internet connectivity and try again.";
    }
    
    handler(nil, [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey: message}], nil);
}

- (void)cancel {
    self.cancelled = YES;
}

- (void)getAlbums:(OLFacebookAlbumRequestHandler)handler {
    __block BOOL runOnce = NO;
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",  @"user_photos"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      if (runOnce || self.cancelled) {
                                          return;
                                      }
                                      
                                      runOnce = YES;
                                      if (error) {
                                          [OLFacebookAlbumRequest handleFacebookError:error completionHandler:handler];
                                          return;
                                      } else if (!FB_ISSESSIONOPENWITHSTATE(state)) {
                                          NSString *message = @"Failed to access your Facebook photos. Please check your internet connectivity and try again.";
                                          handler(nil, [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey: message}], nil);
                                      } else {
                                          // connection is open, perform the request
                                          [FBRequestConnection startWithGraphPath:@"me/albums?limit=100&fields=id,name,count,cover_photo" completionHandler:^(FBRequestConnection *connection,
                                                                                                                                                              id result,
                                                                                                                                                              NSError *error) {
                                              if (self.cancelled) {
                                                  return;
                                              }
                                              
                                              NSString *parsingErrorMessage = @"Failed to parse Facebook Response. Please check your internet connectivity and try again.";
                                              NSError *parsingError = [NSError errorWithDomain:kOLErrorDomainFacebookImagePicker code:kOLErrorCodeFacebookImagePickerBadResponse userInfo:@{NSLocalizedDescriptionKey: parsingErrorMessage}];
                                              id data = [result objectForKey:@"data"];
                                              if (![data isKindOfClass:[NSArray class]]) {
                                                  handler(nil, parsingError, nil);
                                                  return;
                                              }
                                              
                                              NSMutableArray *albums = [[NSMutableArray alloc] init];
                                              for (id album in data) {
                                                  if (![album isKindOfClass:[NSDictionary class]]) {
                                                      continue;
                                                  }
                                                  
                                                  id albumId     = [album objectForKey:@"id"];
                                                  id photoCount  = [album objectForKey:@"count"];
                                                  id coverPhoto  = [album objectForKey:@"cover_photo"];
                                                  id name        = [album objectForKey:@"name"];
                                                  
                                                  if (!([albumId isKindOfClass:[NSString class]] && [photoCount isKindOfClass:[NSNumber class]]
                                                        && [coverPhoto isKindOfClass:[NSString class]] && [name isKindOfClass:[NSString class]])) {
                                                      continue;
                                                  }
                                                  
                                                  OLFacebookAlbum *album = [[OLFacebookAlbum alloc] init];
                                                  album.albumId = albumId;
                                                  album.photoCount = [photoCount unsignedIntegerValue];
                                                  album.name = name;
                                                  album.coverPhotoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=thumbnail&access_token=%@", album.albumId, session.accessTokenData.accessToken]];
                                                  [albums addObject:album];
                                                  
//                                                  paging =     {
//                                                      cursors =         {
//                                                          after = ODEwOTc4Njg3MDQ4;
//                                                          before = "MTAxMDA4NDYxODQ3Mzc3OTg=";
//                                                      };
//                                                  };
                                              }
                                              
                                              handler(albums, nil, nil);
                                          }];
                                      }
                                  }];
    
}

@end
