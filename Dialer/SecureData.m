//
//  SecureData.m
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "SecureData.h"

static SecureData *sharedSecureData = nil;

@implementation SecureData

@synthesize keychain = _keychain;

#pragma mark -
#pragma mark Singleton Methods

+ (id)currentSecureData
{
    @synchronized(self) {
        if(sharedSecureData == nil) {
            sharedSecureData = [[super allocWithZone:NULL] init];
        }
    }
    return sharedSecureData;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self currentSecureData] retain];
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
    return UINT_MAX; // denotes an object that cannot be released
}

- (oneway void)release 
{
    // never release
}

- (id)autorelease 
{
    return self;
}

- (id)init
{
    if (self = [super init]) {
        
        // add object init stuff here

        // Create instance of keychain wrapper
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.codespantech.dialer" accessGroup:nil];
    }
    return self;
}

- (void)dealloc 
{
    // should never be called but added for clarity
    [super dealloc];
}

@end
