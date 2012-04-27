//
//  Dialer - UserDefaultsContainerTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//
        
    // Class under test
#import "UserDefaultsContainer.h"

    // Collaborators
#import "Constants.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "UnitTestConstants.h"

@interface UserDefaultsContainerTests : SenTestCase
{
    
}
@end


@implementation UserDefaultsContainerTests

- (void) setUp 
{
    [super setUp];
    
}

- (void) testM5UrlRetrieval
{
    NSString *foundM5Url = [[UserDefaultsContainer current] getValueForKey:M5UrlEndPointName];
    
    assertThat(foundM5Url, equalTo(@"http://www.ChittyChittyBangBang"));
}

@end
