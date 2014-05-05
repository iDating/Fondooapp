//
//  WebServiceAPIController.m
//  JsonParsing
//
//  Created by Deftsoft informatics on 02/03/12.
//  Copyright (c) 2012 DEFTSOFT. All rights reserved.
//

#import "WebServiceAPIController.h"

#import "NSString+SBJSON.h"
#import "NSData+Base64.h"

//static NSString* str = @"http://192.168.0.51/videoapp/vidapi.php/";

static NSString* str = kFondooWebservice;


@interface NSString (URLEncoding)
@property (readonly) NSString *URLEncodedString;
@end

@implementation NSString (URLEncoding)

- (NSString*)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    return result;
}
@end

@implementation WebServiceAPIController


+ (NSDictionary *)executeAPIRequestForMethod:(NSString *)methodName AndRequestBody:(NSString *)requestBody 
{
	NSString *url_String = [[NSString stringWithFormat:@"%@%@%@",str,methodName,requestBody] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url : %@",url_String);
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url_String]];

    
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *response;
	NSError *error;
	NSData *responseData;
	
	responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
   // NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
     NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
	//NSLog(@"Response dict is %@",responseString);
   
	
	if (responseDictionary == nil) {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error..!" message:@"Invalid response from server. Please try again.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
    return responseDictionary;
}


+ (NSDictionary *)executeAPIRequestForMethod1:(NSString *)methodName AndRequestBody:(NSString *)requestBody {
    
	NSString *url_String = [[NSString stringWithFormat:@"%@%@%@", str, methodName, requestBody] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    NSLog(@"Url string is %@",url_String);
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url_String]];
    [request setHTTPMethod:@"POST"];
    
	NSString *requestString;
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"] == nil)	
		requestString = requestBody;
	else 
		requestString = [NSString stringWithFormat:@"session_token=%@&%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"], requestBody];
	
    NSMutableData *body = [NSMutableData data];
    [body appendData:[requestString dataUsingEncoding:NSASCIIStringEncoding]];
    
    [request setHTTPBody:body];
	
	NSHTTPURLResponse *response;
	NSError *error;
	NSData *responseData;
	
	responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
    
	
	//NSLog(@"Response string is %@",responseString);
	
	if (responseDictionary == nil) {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error..!" message:@"Invalid response from server. Please try again.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
    return responseDictionary;
}

@end
