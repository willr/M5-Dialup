//
//  Dialer - ContactListContainerTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "ContactListContainer.h"
#import "ContactListContainer+PrivateMethods.h"

    // Collaborators
#import "AddressBookContainer.h"
#import "Constants.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import <OCMock/OCMock.h>

#import "UnitTestConstants.h"
#import "UnitTestDataFactory.h"

@interface ContactListContainerTests : SenTestCase
{
    id                      _abContainer;
    
    ContactListContainer    *_contactContainer;
    
}

@property (strong, nonatomic) id                    abContainer;
@property (strong, nonatomic) ContactListContainer  *contactContainer;

@end


@implementation ContactListContainerTests

@synthesize abContainer = _abContainer;
@synthesize contactContainer = _contactContainer;

- (void) setUp 
{
    [super setUp];
    
    self.abContainer = [OCMockObject mockForClass:[AddressBookContainer class]];
    self.contactContainer = [[ContactListContainer alloc] init];
    self.contactContainer.abContainer = self.abContainer;
}

- (void) testCountNumberOfContactRecordsEquals7
{
    NSArray *contactList = [[UnitTestDataFactory loadContactEntries] objectForKey:ContactArrayName];
    self.contactContainer.contactList = (NSMutableArray *)contactList;
    
    NSUInteger retCount = [self.contactContainer count];
    
    assertThatUnsignedInteger(retCount, equalToUnsignedInt([contactList count]));
    
}

- (void) testPersonAtIndexOneEqualsJamesJoyce
{
    NSArray *contactList = [[UnitTestDataFactory loadContactEntries] objectForKey:ContactArrayName];
    self.contactContainer.contactList = (NSMutableArray *)contactList;
    
    NSDictionary *found = [self.contactContainer personAtIndex:2];
    NSString *foundName = [found objectForKey:PersonName];
    
    assertThat(foundName, equalTo(@"James Joyce"));
    
}

- (void) testGetCopyFromPhoneEntryAndPlaceIntoDictionary
{
    self.contactContainer.abContainer = self.abContainer;
    
    ABMultiValueRef multiValueRef = (ABMultiValueRef)@"this is a test";
    NSString *phoneLabel = @"iPhone";
    CFIndex index = 1;
    NSMutableDictionary *placedInto = [[NSMutableDictionary alloc] init];
    int phoneId = 9;
    
    NSString *phoneNumber = @"512-333-1212";
    
    [[[self.abContainer stub] andReturn:phoneNumber] multiValueCopyValueAtIndex:multiValueRef index:index];
    
    [self.contactContainer getCopyFrom:multiValueRef 
                               withKey:(CFStringRef)phoneLabel 
                               atIndex:index 
                             placeInto:placedInto 
                         havingPhoneId:phoneId];
    
    NSDictionary *foundPhoneEntry = [placedInto objectForKey:[NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel, index]];
    assertThat(foundPhoneEntry, notNilValue());
    
    NSNumber *foundPhoneId = [foundPhoneEntry objectForKey:PersonPhoneId];
    assertThat(foundPhoneId, equalTo([NSNumber numberWithInt:phoneId])); 
    NSString *foundPhoneNumber = [foundPhoneEntry objectForKey:PersonPhoneNumber];
    assertThat(foundPhoneNumber, equalTo(phoneNumber));
    
    [self.abContainer verify];
    
    [placedInto release];
    
}

@end







