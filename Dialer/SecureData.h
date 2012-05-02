//
//  SecureData.h
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface SecureData : NSObject
{
    KeychainItemWrapper *_userNamePasswordKeychain;
    KeychainItemWrapper *_sourcePhoneNumberKeychain;
}

@property (nonatomic, retain) KeychainItemWrapper *userNamePasswordKeychain;
@property (nonatomic, retain) KeychainItemWrapper *sourcePhoneNumberKeychain;

+ (id)current;

- (void) setUserNameValue:(NSString *)userName;
- (NSString *) userNameValue;

- (void) setPasswordValue:(NSString *)password;
- (NSString *) passwordValue;

- (void) setSourcePhoneNumberValue:(NSString *)password;
- (NSString *) sourcePhoneNumberValue;

// Initializes and resets the default generic keychain item data.
- (void)reset;

@end
