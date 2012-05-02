//
//  Dialer - SecureDataTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "SecureData.h"

    // Collaborators
#import "Constants.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "UnitTestConstants.h"

@interface SecureDataTests : SenTestCase
{
    SecureData *_secureData;
}

@property (nonatomic, retain) SecureData *secureData;

@end


@implementation SecureDataTests

@synthesize secureData = _secureData;

- (void) setUp 
{
    [super setUp];
    
}

- (void) testSetValueUserNamePassword
{
    SecureData *secureData = [SecureData current];
    
    NSString * myTestPassword = @"My Test Data";
    NSString * myTestUserName = @"TestKey";
    
    // test username
    [secureData setUserNameValue:myTestUserName];
    
    secureData = nil;
    
    secureData = [SecureData current];
    NSString *foundUserNameString = [secureData userNameValue];
    
    assertThat(foundUserNameString, equalTo(myTestUserName));
    
    // test password
    [secureData setPasswordValue:myTestPassword];
    
    secureData = nil;
    
    secureData = [SecureData current];
    NSString *foundPasswordString = [secureData passwordValue];
    
    assertThat(foundPasswordString, equalTo(myTestPassword));
    
    // test phoneNumber
    [secureData setSourcePhoneNumberValue:@"123"];
    
    secureData = nil;
    
    secureData = [SecureData current];
    NSString *foundPhoneString = [secureData sourcePhoneNumberValue];
    
    assertThat(foundPhoneString, equalTo(@"123"));
    
    [secureData reset];

}



@end










//