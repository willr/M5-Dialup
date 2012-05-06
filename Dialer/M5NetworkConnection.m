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

// dial a phone number and notify the delegate at each point in the call
- (void) dialPhoneNumber:(NSString *)destPhoneNumber
{
    // set the current phone number we are dealing with
    self.currentPhoneNumber = destPhoneNumber;
    
    // create the URL for the GET request
    SecureData *secure = [SecureData current];
    NSString *dialCmd = [NSString stringWithFormat:M5DialCmdFormat, 
                         M5HostAddress, 
                         M5HostPath, 
                         [secure sourcePhoneNumberValue], 
                         [secure passwordValue], 
                         destPhoneNumber];
    
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
    [self.connDelegate updateDialingStatus:kCompletedConnection forNumber:self.currentPhoneNumber];
    
    // dispatch back to the mainUI thread to handle the displaying of the error message
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    // release the connection, and the data object
    self.connection = nil;
    self.receivedData = nil;
    
    // update the connDelegate of the connectionComplete status
    [self.connDelegate updateDialingStatus:kCompletedConnection forNumber:self.currentPhoneNumber];
}

#pragma mark - junk

// this is an inital trial implementation, will be ignored.
- (void) oldNetworkRequestTo:(CFStringRef)urlString
{
    // urlString = (CFStringRef)@"http://www.apple.com";
    
    CFStringRef url = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, urlString, NULL, NULL, kCFStringEncodingUTF8);
    // log for now, later delete
    NSLog(@"Connecting with dialCmd: %@", url);
    CFURLRef connUrl = CFURLCreateWithString(kCFAllocatorDefault, url, NULL);
    CFStringRef getVerb = CFSTR("GET");
    CFHTTPMessageRef request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, getVerb, connUrl, kCFHTTPVersion1_1);

    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, request);
    CFReadStreamOpen(readStream);
    
    CFIndex bytes;
    int bufSize = 1024;
    UInt8 buf[bufSize];
    
    do {
        bytes = CFReadStreamRead(readStream, buf, sizeof(buf));
        if( bytes > 0 ){
            // NSString *responseString = [[NSString alloc] initWithBytes:buf length:bytes encoding:NSUTF8StringEncoding];
            // NSLog(responseString); 
        } else if( bytes < 0 ) {
            // CFStreamError error = CFReadStreamGetError(readStream);
            // int ii = 0;
        }
    } while( bytes > 0 );
    
    CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
    
    CFStringRef statusLine = CFHTTPMessageCopyResponseStatusLine(response);
    UInt32 errorCode = CFHTTPMessageGetResponseStatusCode(response);
    
    NSLog(@"Response: %@ -- ErrorCode: %lu", statusLine, errorCode);
    
    
    if(connUrl != nil) CFRelease(connUrl);
    if(request != nil) CFRelease(request);
    if(response != nil) CFRelease(response);
    if(statusLine != nil) CFRelease(statusLine);
    
    if(readStream != nil) CFRelease(readStream);
    
    request = NULL;
    
}

@end
















//
