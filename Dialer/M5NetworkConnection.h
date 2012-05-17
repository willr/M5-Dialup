//
//  M5NetworkConnection.h
//  Dialer
//
//  Created by William Richardson on 5/5/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DialingNetConnectionDelegate.h"
#import "M5ResponseMessage.h"

@interface M5NetworkConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSString                            *_currentPhoneNumber;
    NSMutableData                       *_receivedData;
    NSURLConnection                     *_connection;
    
    id<DialingNetConnectionDelegate>    _connDelegate;
}

@property (nonatomic, retain) NSString                          *currentPhoneNumber;
@property (nonatomic, retain) id<DialingNetConnectionDelegate>  connDelegate;
@property (nonatomic, retain) NSMutableData                     *receivedData;
@property (nonatomic, retain) NSURLConnection                   *connection;

- (void) dialPhoneNumber:(NSString *)destPhoneNumber;

- (NSURL *)smartURLForString:(NSString *)str;

@end
