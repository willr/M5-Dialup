//
//  Dialer - UnitTestDataFactoryTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "UnitTestDataFactory.h"

    // Collaborators
#import "UnitTestConstants.h"
#import "Constants.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface UnitTestDataFactoryTests : SenTestCase
{
    
}
@end


@implementation UnitTestDataFactoryTests

- (void)testDataFactoryCreateContactList
{

    NSDictionary *contactList = [UnitTestDataFactory createContactEntries];
    
    NSLog(@"output of %@: %@\n", ContactArrayName, [contactList objectForKey:ContactArrayName]);
    
    NSLog(@"output of %@: %@", ContactLookupName, [contactList objectForKey:ContactLookupName]);
    
}

- (void)testDataFactoryUsersCreated
{
    NSDictionary *userA = [UnitTestDataFactory createUserA];
    NSLog(@"UserA: %@", userA);
    
    assertThat([userA objectForKey:PersonName], equalTo(UserAName));
    
    NSDictionary *userB = [UnitTestDataFactory createUserB];
    NSLog(@"UserB: %@", userB);    
    
    assertThat([userB objectForKey:PersonName], equalTo(UserBName));
}

- (void) testContactListLoaded
{
    NSDictionary *contactInfo = [UnitTestDataFactory loadContactEntries];
    NSArray *contactList = [contactInfo objectForKey:ContactArrayName];
    // NSDictionary *contactLookup = [contactInfo objectForKey:ContactLookupName];
    
    assertThat([NSNumber numberWithInt:[contactList count]], greaterThan([NSNumber numberWithInt:1]));
    bool found = false;
    
    for (NSDictionary *entry in contactList) {
        NSString *name = [entry objectForKey:PersonName];
        NSLog(@"Found Name: %@", name);
        if ([name isEqualToString:@"Joe User"]) {
            found = true;
        }
    }
    
    assertThatBool(found, equalToBool(true));
}

- (void) testGetFirstPhoneId
{
    NSDictionary *person = [UnitTestDataFactory createUserB];
    
    
    NSNumber *phoneId = [UnitTestDataFactory getFirstFoundPhoneId:person];
    
    assertThat(phoneId, equalTo([NSNumber numberWithInt:10]));
    
    NSMutableArray *foundPhoneIds = [[NSMutableArray alloc] init];
    
    for (NSDictionary *phoneEntry in [[person objectForKey:PersonPhoneList] allValues]) {
        NSNumber *phoneId = [phoneEntry objectForKey:PersonPhoneId];
        
        
        BOOL found = [foundPhoneIds containsObject:phoneId];
        if (found) {
            
            NSLog(@"Found duplicated phoneId: %@", phoneId);
            [NSException raise:@"Found duplicated phoneId value" format:@"phoneId %d is a duplicate", [phoneId intValue]];        
        }
        
        [foundPhoneIds addObject:phoneId];
    }
}

@end






