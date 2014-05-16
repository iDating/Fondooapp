//
//  AFWebClient.h
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/14/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"

@interface AFWebClient : AFHTTPSessionManager

+ (id)  sharedInstance;

- (void) requestFromSetupView:(NSMutableDictionary *)dict;
- (void) requestFromSetupView:(NSMutableDictionary *)dictionary completion:(void (^)(NSURLSessionDataTask *task, id responseObject))success;

- (void) uploadImage:(NSData *)data;
- (void) uploadImageFile:(NSString *)file;

@end
