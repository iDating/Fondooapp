//
//  WebClient.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/13/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "WebClient.h"

#import "WebServiceAPIController.h"

@implementation WebClient

static WebClient *gWebClient = nil;

+ (id)  sharedInstance
{
    if (!gWebClient)
        gWebClient = [[WebClient alloc] init];
    return gWebClient;
}

- (void) sendDataFromSetupView:(NSString *)body Method:(NSString *)method
{
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:method AndRequestBody:body];
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
    else
    {
        
    }
}

@end
