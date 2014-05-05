//
//  WebServiceAPIController.h
//  JsonParsing
//
//  Created by Deftsoft informatics on 02/03/12.
//  Copyright (c) 2012 DEFTSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceAPIController : NSObject
{
    
}

+ (NSDictionary *)executeAPIRequestForMethod:(NSString *)methodName AndRequestBody:(NSString *)requestBody; 
+ (NSDictionary *)executeAPIRequestForMethod1:(NSString *)methodName AndRequestBody:(NSString *)requestBody;

@end
