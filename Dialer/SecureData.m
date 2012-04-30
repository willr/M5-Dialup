//
//  SecureData.m
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "SecureData.h"

#import "Constants.h"

static SecureData *sharedSecureData = nil;

@implementation SecureData

@synthesize keychain = _keychain;


- (void) setUserNameValue:(NSString *)userName
{
    [self.keychain setObject:kSecAttrAccount forKey:userName];
}

- (NSString *) userNameValue
{
    return [self.keychain objectForKey:kSecAttrAccount];
}

- (void) setPasswordValue:(NSString *)password
{
    [self.keychain setObject:kSecValueData forKey:password];
}
- (NSString *) passwordValue
{
    return [self.keychain objectForKey:kSecValueData];
}

// Initializes and resets the default generic keychain item data.
- (void)reset
{
    [self.keychain resetKeychainItem];
}

#pragma mark -
#pragma mark Singleton Methods

+ (SecureData *)current
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
    return [[self current] retain];
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
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:KeychainUserPasswordIdentifier accessGroup:nil];
    }
    return self;
}

- (void)dealloc 
{
    // should never be called but added for clarity
    [super dealloc];
}

@end
