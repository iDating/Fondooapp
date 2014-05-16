//
//  AFWebClient.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/14/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "AFWebClient.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

#import "CommonClass.h"

#define FONDOO_SERVICE_URL  @"http://www.fondooapp.co/Webservices"
#define SERVICE_API         @"services.php"

@implementation AFWebClient

static AFWebClient * gSharedClient = nil;

+ (id)  sharedInstance
{
    if (!gSharedClient)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gSharedClient = [[AFWebClient alloc] initWithBaseURL:[NSURL URLWithString:FONDOO_SERVICE_URL]];
            gSharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
         });
    }
    return gSharedClient;
}

- (void) requestFromSetupView:(NSMutableDictionary *)dictionary
{
    NSString *authKey = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"];
    [dictionary setObject:authKey forKey:kAuthKeyParam];
    [self GET:SERVICE_API parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"return"] intValue]==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dict objectForKey:@"totalImageset"] == [NSNull null]) {
                    NSMutableDictionary *dictmain=[[NSMutableDictionary alloc] initWithDictionary:dict];
                    [dictmain setObject:@"0" forKey:@"totalImageset"];
                    [[NSUserDefaults standardUserDefaults] setObject:dictmain forKey:@"userinfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"editProfile" object:nil];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error description]);
    }];
}

- (void) requestFromSetupView:(NSMutableDictionary *)dictionary completion:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    NSString *authKey = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"];
    [dictionary setObject:authKey forKey:kAuthKeyParam];
    [self GET:SERVICE_API parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         success(task, responseObject);
     } failure:nil];
}

- (void) uploadImage:(NSData *)imageData
{
    [self POST:@"images/upload1.php" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        
        NSString *fileName = @"tmp_file.jpg";
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:fileName mimeType:@"image/jpg"];
    } success:^(NSURLSessionDataTask * task, id responderData) {
        NSLog(@"Success: %@", responderData);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"Error: %@",error);
    }];
}

@end
