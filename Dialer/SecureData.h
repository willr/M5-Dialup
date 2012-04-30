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
    KeychainItemWrapper *_keychain;
}

@property (nonatomic, retain) KeychainItemWrapper *keychain;

+ (id)current;

- (void) setUserNameValue:(NSString *)userName;
- (NSString *) userNameValue;

- (void) setPasswordValue:(NSString *)password;
- (NSString *) passwordValue;

// Initializes and resets the default generic keychain item data.
- (void)reset;

@end
