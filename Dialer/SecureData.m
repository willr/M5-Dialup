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

@synthesize userNamePasswordKeychain = _userNamePasswordKeychain;
@synthesize sourcePhoneNumberKeychain = _sourcePhoneNumberKeychain;

- (void) setUserNameValue:(NSString *)userName
{
    [self.userNamePasswordKeychain setObject:userName forKey:kSecAttrAccount];
}

- (NSString *) userNameValue
{
    return [self.userNamePasswordKeychain objectForKey:kSecAttrAccount];
}

- (void) setPasswordValue:(NSString *)password
{
    [self.userNamePasswordKeychain setObject:password forKey:kSecValueData];
}

- (NSString *) passwordValue
{
    return [self.userNamePasswordKeychain objectForKey:kSecValueData];
}

- (void) setSourcePhoneNumberValue:(NSString *)phoneNumber
{
    [self.sourcePhoneNumberKeychain setObject:@"M5Dialer::phoneNumber" forKey:kSecAttrAccount];
    [self.sourcePhoneNumberKeychain setObject:phoneNumber forKey:kSecValueData];
}

- (NSString *) sourcePhoneNumberValue
{
    return [self.sourcePhoneNumberKeychain objectForKey:kSecValueData];
}

// Initializes and resets the default generic keychain item data.
- (void)reset
{
    [self.sourcePhoneNumberKeychain resetKeychainItem];
    [self.userNamePasswordKeychain resetKeychainItem];
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
        
        // need two instances of the keychain wrappers, one for the username/password combo, other for phoneNumber.
        // if more needed in the future, then new keychain wrapper will have to be created for each new iten needed.
        _userNamePasswordKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:KeychainUserPasswordIdentifier accessGroup:nil];
        _sourcePhoneNumberKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:KeychainPhoneNumberIdendifier accessGroup:nil];
    }
    return self;
}

- (void)dealloc 
{
    // should never be called but added for clarity
    [super dealloc];
}

@end
