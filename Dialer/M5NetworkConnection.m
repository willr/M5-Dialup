//
//  M5NetworkConnection.m
//  Dialer
//
//  Created by William Richardson on 5/5/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "M5NetworkConnection.h"
#import "M5NetworkConnection+PrivateMethods.h"

#import "Constants.h"
#import "SecureData.h"
#import "AppDelegate.h"
#import "TestFlight.h"

@implementation M5NetworkConnection

@synthesize currentPhoneNumber = _currentPhoneNumber;
@synthesize connDelegate = _connDelegate;
@synthesize receivedData = _receivedData;
@synthesize connection = _connection;

- (void) dealloc
{
    self.currentPhoneNumber = nil;
    self.connDelegate = nil;
    self.receivedData = nil;
    self.connection = nil;
    
    [super dealloc];
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            // result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
            NSString *trimmedNoLocStr = [NSString stringWithFormat:@"http://%@", trimmedStr];
            CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)trimmedNoLocStr, NULL, NULL, kCFStringEncodingUTF8);
            result = [NSURL URLWithString:(NSString *)urlString];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                // result = [NSURL URLWithString:trimmedStr];
                CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)trimmedStr, NULL, NULL, kCFStringEncodingUTF8);
                result = [NSURL URLWithString:(NSString *)urlString];
                
            } else {
                // It looks like this is some unsupported URL scheme.
                NSAssert(@"Looks like this is some unsupported URL scheme: %@", scheme);
            }
        }
    }
    
    return result;
}

- (NSString *)getPhoneNumberDigitsRegex:(NSString *)phoneNumber
{
    // Setup an NSError object to catch any failures
	NSError *error = NULL;
    
    // create the NSRegularExpression object and initialize it with a pattern
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PhoneNumberDigitsPattern 
                                                                           options:NSRegularExpressionCaseInsensitive 
                                                                             error:&error];
    
    if (regex == nil && error) {
        RTFLog(@"getPhoneNumberDigitsRegex ERROR:: Pattern: %@, Error Desc: %@, Error Code: %@, Error Domain: %@", PhoneNumberDigitsPattern, 
               error.localizedDescription, 
               error.code, 
               error.domain);

        
        [((AppDelegate *)[UIApplication sharedApplication].delegate) displayErrorMessage:@"Error parsing Contact info" 
                                                                          additionalInfo:nil 
                                                                               withError:error];
    }
    
    // get the result of the regEx
    NSArray *results = [regex matchesInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
    
    NSString *digits = @"";
    if (results != nil) {
        // iterate through the results, we pull each contiguous substring range out one at a time
        for (NSTextCheckingResult *result in results) {
            NSRange range = [result rangeAtIndex:0];
            /*
             NSLog(@"%d,%d group #%d %@", range.location, range.length, 0,
             (range.length == 0 ? @"--" : [phoneNumber substringWithRange:range]));
             */
            if (range.length == 0) {
                continue;
            }
            
            // with the given range, append to the string we are building
            digits = [digits stringByAppendingString:[phoneNumber substringWithRange:range]];
        }
    }
    
    // NSLog(@"digits: %@", digits);
    return digits;
}

// dial a phone number and notify the delegate at each point in the call
- (void) dialPhoneNumber:(NSString *)destPhoneNumber
{
    // set the current phone number we are dealing with
    self.currentPhoneNumber = destPhoneNumber;
    
    // create the URL for the GET request
    SecureData *secure = [SecureData current];
    NSString *secureSourcePhoneNumberDigits = [self getPhoneNumberDigitsRegex:[secure sourcePhoneNumberValue]];
    
    NSString *dialCmd = [NSString stringWithFormat:M5DialCmdFormat, 
                         M5HostAddress, 
                         M5HostPath, 
                         secureSourcePhoneNumberDigits, 
                         [secure passwordValue], 
                         destPhoneNumber];
    
    
    #define TESTING 1
    #ifdef TESTING
    NSString *dialNoPassCmd = [NSString stringWithFormat:M5DialCmdFormat, 
                               M5HostAddress, 
                               M5HostPath, 
                               secureSourcePhoneNumberDigits, 
                               destPhoneNumber];
    
    RTFLog(@"M5 DialCmd: %@", dialNoPassCmd);
    #endif 
    
    [self networkRequestTo:dialCmd];

}

- (void) updateConnectionStatus:(ConnectionStatus)status forNumber:destPhoneNumber
{
    // dispatch back to the mainUI thread to handle the updating of the status
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // update the connDelegate of the connecting status
        [self.connDelegate updateDialingStatus:status forNumber:destPhoneNumber];
        
    });
}

// we are going to assume all requests are "GET" requests since that is implementation we are basing off of
- (void) networkRequestTo:(NSString *)urlString
{
    // sanatize the provided UrlString
    NSURL *smartUrl = [self smartURLForString:urlString];
    NSLog(@"smartUrl: %@", smartUrl);
    
    // create the request
    NSURLRequest *request = [NSURLRequest requestWithURL:smartUrl 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    
    // update the connDelegate of the connecting status
    [self updateConnectionStatus:kConnectingConnection forNumber:self.currentPhoneNumber];
    
    // create the connection for the request
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection != nil) {
        // create the nsdata to hold the receivedData
        self.receivedData = [NSMutableData data];
    } else {
        NSAssert(@"Failed to connect to Url: %@", urlString);
    }
}

#pragma mark - NSURLConnectionDelegate
// an error occured on the connection
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // update the connDelegate of the connectionComplete status
    [self.connDelegate updateDialingStatus:kErroredConnection forNumber:self.currentPhoneNumber];
    
    // dispatch back to the mainUI thread to handle the displaying of the error message
    dispatch_async(dispatch_get_main_queue(), ^{
        
        RTFLog(@"connectionDidFailWithError ERROR:: phoneNumber: %@, Error Desc: %@, Error Code: %@, Error Domain: %@", 
               self.currentPhoneNumber, 
               error.localizedDescription, 
               error.code, 
               error.domain);
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate) displayErrorMessage:@"Error connecting to URL for phone call" 
                                                                          additionalInfo:@"Try again" 
                                                                               withError:error];
        
    });
    
    // release the connection, and the data object
    [connection release];
    self.receivedData = nil;
}

#pragma mark - NSURLConnectionDataDelegate

// we are being notified that a redirect is happening
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // clear the previous response and set this as the new one
    [self.receivedData setLength:0];
    
    // update the connDelegate of the connectionComplete status
    [self.connDelegate updateDialingStatus:kConnectingConnection forNumber:self.currentPhoneNumber];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    /*
    NSString* newStr = [[[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding] autorelease];
    */
    
    // NSLog(@"output: %@", newStr);
    
    // release the connection, and the data object
    self.connection = nil;
    self.receivedData = nil;
    
    // update the connDelegate of the connectionComplete status
    [self.connDelegate updateDialingStatus:kCompletedConnection forNumber:self.currentPhoneNumber];
}

@end
















//
