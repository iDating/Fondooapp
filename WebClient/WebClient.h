//
//  WebClient.h
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/13/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebClient : NSObject
{
    
}

+ (id)  sharedInstance;

- (void) sendDataFromSetupView:(NSString *)body Method:(NSString *)method;

@end
