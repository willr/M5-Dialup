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
    ABMultiValueRef multiValueRef = (ABMultiValueRef)@"this is a test";
    NSString *phoneLabel = @"iPhone";
    CFIndex index = 1;
    NSMutableDictionary *placedInto = [[NSMutableDictionary alloc] init];
    int phoneId = 9;
    
    NSString *phoneNumber = @"512-333-1212";
    
    [[[self.abContainer stub] andReturn:phoneNumber] copyMultiValueValueAtIndex:multiValueRef index:index];
    
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

- (void) testAddUserToPersonDictionary
{
    ABRecordRef record = (ABRecordRef)@"this is a test";
    NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
    
    NSString *firstName = @"Joe";
    NSString *lastName = @"User";
    
    [[[self.abContainer expect] andReturn:firstName] copyRecordValue:record propertyId:kABPersonFirstNameProperty];
    [[[self.abContainer expect] andReturn:lastName] copyRecordValue:record propertyId:kABPersonLastNameProperty];
    
    [self.contactContainer addUserName:record dOfPerson:person];
    NSString *name = [person objectForKey:PersonName];
    
    assertThat(name, equalTo([NSString stringWithFormat:PersonNameFormat, firstName, lastName]));
    
    [self.abContainer verify];
}

- (void) testAddContactPhonesOfPersonToLists
{
    ABRecordRef record = (ABRecordRef)@"this is a test";
    ABMultiValueRef phones = (ABMultiValueRef)@"phones";
    
    NSMutableDictionary *person = (NSMutableDictionary *)[UnitTestDataFactory createUserA];
    NSNumber *phoneId = [UnitTestDataFactory getFirstFoundPhoneId:person];
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    NSMutableDictionary *contactLookup = [[NSMutableDictionary alloc] init];
    
    [[[self.abContainer expect] andReturn:phones] copyRecordValue:record propertyId:kABPersonPhoneProperty];
    CFIndex recordCount = (CFIndex)2;
    [[[self.abContainer expect] andReturnValue:OCMOCK_VALUE(recordCount)] multiValueGetCount:phones];
    
    [[[self.abContainer expect] andReturn:@"FirstNameA"] copyRecordValue:record propertyId:kABPersonFirstNameProperty];
    [[[self.abContainer expect] andReturn:@"LastNameA"] copyRecordValue:record propertyId:kABPersonLastNameProperty];
    
    NSString *phoneLabel0 = @"iPhone";
    [[[self.abContainer expect] andReturn:phoneLabel0] copyMultiValueLabelAtIndex:phones index:0];
    NSString *phoneNumber0 = @"512-000-0000";
    [[[self.abContainer expect] andReturn:phoneNumber0] copyMultiValueValueAtIndex:phones index:0];

    NSString *phoneLabel1 = @"Home";
    [[[self.abContainer expect] andReturn:phoneLabel1] copyMultiValueLabelAtIndex:phones index:1];
    NSString *phoneNumber1 = @"512-111-1111";
    [[[self.abContainer expect] andReturn:phoneNumber1] copyMultiValueValueAtIndex:phones index:1];
    
    
    int phoneIdInt = [phoneId intValue];
    [self.contactContainer addContactPhones:record dOfPerson:person phoneId:&phoneIdInt contactList:contactList contactLookup:contactLookup];
    
    [self.abContainer verify];
    
    assertThatInt([contactList count], equalToInt(1));

    NSDictionary *phoneList = [[contactList objectAtIndex:0] objectForKey:PersonPhoneList];
    assertThatInteger([phoneList count], equalToInt(2));
    
    NSString *expectedPhoneLabel = [NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel0, 0];
    NSString *firstPhoneEntry = [[phoneList allKeys] objectAtIndex:0];
    assertThat(firstPhoneEntry, equalTo(expectedPhoneLabel));
    
    NSString *firstPhoneNumber = [[[phoneList allValues] objectAtIndex:0] objectForKey:PersonPhoneNumber];
    assertThat(firstPhoneNumber, equalTo(phoneNumber0));
    
}

- (void) testCollectAddressBookInfo
{
    ABRecordRef record1 = (ABRecordRef)@"contact1";
    ABRecordRef record2 = (ABRecordRef)@"contact2";
    NSArray *recordArrayRef = [[NSArray alloc] initWithObjects:record1, record2, nil];
    CFIndex personCount = 2;
    
    ABMultiValueRef phones = (ABMultiValueRef)@"phones";
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    NSMutableDictionary *contactLookup = [[NSMutableDictionary alloc] init];
    
    self.contactContainer.contactList = contactList;
    self.contactContainer.contactLookup = contactLookup;
    
    [[self.abContainer stub] addressBookCreate];
    
    [[[self.abContainer expect] andReturn:recordArrayRef] copyAddressBookArrayOfAllPeople];
    [[[self.abContainer expect] andReturnValue:OCMOCK_VALUE(personCount)] addressBookGetPersonCount];
    
    // addContactPhones method start
    [[[self.abContainer expect] andReturn:phones] copyRecordValue:record1 propertyId:kABPersonPhoneProperty];
    CFIndex recordCount1 = (CFIndex)2;
    [[[self.abContainer expect] andReturnValue:OCMOCK_VALUE(recordCount1)] multiValueGetCount:phones];
    
    // userA
    [[[self.abContainer expect] andReturn:@"FirstNameA"] copyRecordValue:record1 propertyId:kABPersonFirstNameProperty];
    [[[self.abContainer expect] andReturn:@"LastNameA"] copyRecordValue:record1 propertyId:kABPersonLastNameProperty];
    
    NSString *phoneLabel0 = @"iPhone";
    [[[self.abContainer expect] andReturn:phoneLabel0] copyMultiValueLabelAtIndex:phones index:0];
    NSString *phoneNumber0 = @"512-000-0000";
    [[[self.abContainer expect] andReturn:phoneNumber0] copyMultiValueValueAtIndex:phones index:0];
    
    NSString *phoneLabel1 = @"Home";
    [[[self.abContainer expect] andReturn:phoneLabel1] copyMultiValueLabelAtIndex:phones index:1];
    NSString *phoneNumber1 = @"512-111-1111";
    [[[self.abContainer expect] andReturn:phoneNumber1] copyMultiValueValueAtIndex:phones index:1];
    
    [[[self.abContainer expect] andReturn:phones] copyRecordValue:record2 propertyId:kABPersonPhoneProperty];
    CFIndex recordCount2 = (CFIndex)2;
    [[[self.abContainer expect] andReturnValue:OCMOCK_VALUE(recordCount2)] multiValueGetCount:phones];
    
    // userB
    [[[self.abContainer expect] andReturn:@"FirstNameB"] copyRecordValue:record2 propertyId:kABPersonFirstNameProperty];
    [[[self.abContainer expect] andReturn:@"LastNameB"] copyRecordValue:record2 propertyId:kABPersonLastNameProperty];
    
    NSString *phoneLabel3 = @"Work";
    [[[self.abContainer expect] andReturn:phoneLabel3] copyMultiValueLabelAtIndex:phones index:0];
    NSString *phoneNumber3 = @"512-333-3333";
    [[[self.abContainer expect] andReturn:phoneNumber3] copyMultiValueValueAtIndex:phones index:0];
    
    NSString *phoneLabel4 = @"Mobile";
    [[[self.abContainer expect] andReturn:phoneLabel4] copyMultiValueLabelAtIndex:phones index:1];
    NSString *phoneNumber4 = @"512-444-4444";
    [[[self.abContainer expect] andReturn:phoneNumber4] copyMultiValueValueAtIndex:phones index:1];
    // addContactPhones method end
    
    
    [self.contactContainer collectAddressBookInfo];
    
    [self.abContainer verify];
    
    assertThatInt([contactList count], equalToInt(2));
    
    NSDictionary *userA = [contactList objectAtIndex:0];
    NSString *userNameA = [userA objectForKey:PersonName];
    assertThat(userNameA, equalTo(@"FirstNameA LastNameA"));
    
    NSDictionary *phoneList1 = [userA objectForKey:PersonPhoneList];
    assertThatInteger([phoneList1 count], equalToInt(2));
    
    NSString *expectedPhoneLabel1 = [NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel0, 0];
    NSString *firstPhoneEntry1 = [[phoneList1 allKeys] objectAtIndex:0];
    assertThat(firstPhoneEntry1, equalTo(expectedPhoneLabel1));
    
    NSDictionary *phoneEntry1 = [[phoneList1 allValues] objectAtIndex:0];
    NSString *firstPhoneNumber1 = [phoneEntry1 objectForKey:PersonPhoneNumber];
    assertThat(firstPhoneNumber1, equalTo(phoneNumber0));
    assertThatInt([[phoneEntry1 objectForKey:PersonPhoneId] intValue], equalToInt(1));
    
    NSString *expectedPhoneLabel2 = [NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel1, 1];
    NSString *firstPhoneEntry2 = [[phoneList1 allKeys] objectAtIndex:1];
    assertThat(firstPhoneEntry2, equalTo(expectedPhoneLabel2));
    
    NSDictionary *phoneEntry2 = [[phoneList1 allValues] objectAtIndex:1];
    NSString *firstPhoneNumber2 = [phoneEntry2 objectForKey:PersonPhoneNumber];
    assertThat(firstPhoneNumber2, equalTo(phoneNumber1));
    assertThatInt([[phoneEntry2 objectForKey:PersonPhoneId] intValue], equalToInt(2));
    
    NSDictionary *userB = [contactList objectAtIndex:1];
    NSString *userNameB = [userB objectForKey:PersonName];
    assertThat(userNameB, equalTo(@"FirstNameB LastNameB"));
    
    NSDictionary *phoneList2 = [userB objectForKey:PersonPhoneList];
    assertThatInteger([phoneList2 count], equalToInt(2));
    
    NSString *expectedPhoneLabel3 = [NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel3, 0];
    NSString *firstPhoneEntry3 = [[phoneList2 allKeys] objectAtIndex:0];
    assertThat(firstPhoneEntry3, equalTo(expectedPhoneLabel3));
    
    NSDictionary *phoneEntry3 = [[phoneList2 allValues] objectAtIndex:0];
    NSString *firstPhoneNumber3 = [phoneEntry3 objectForKey:PersonPhoneNumber];
    assertThat(firstPhoneNumber3, equalTo(phoneNumber3));
    assertThatInt([[phoneEntry3 objectForKey:PersonPhoneId] intValue], equalToInt(3));
    
    NSString *expectedPhoneLabel4 = [NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel4, 1];
    NSString *firstPhoneEntry4 = [[phoneList2 allKeys] objectAtIndex:1];
    assertThat(firstPhoneEntry4, equalTo(expectedPhoneLabel4));
    
    NSDictionary *phoneEntry4 = [[phoneList2 allValues] objectAtIndex:1];
    NSString *firstPhoneNumber4 = [phoneEntry4 objectForKey:PersonPhoneNumber];
    assertThat(firstPhoneNumber4, equalTo(phoneNumber4));
    assertThatInt([[phoneEntry4 objectForKey:PersonPhoneId] intValue], equalToInt(4));
}

@end







