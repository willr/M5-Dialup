//
//  Dialer - ContactBaseContainerTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "ContactBaseContainer.h"

    // Collaborators
#import "Constants.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMock/OCMock.h>

#import "UnitTestConstants.h"
#import "UnitTestDataFactory.h"

@interface ContactBaseContainerTests : SenTestCase
{
    ContactBaseContainer *_baseContainer;
    
}

@property (strong, nonatomic) ContactBaseContainer *baseContainer;

@end


@implementation ContactBaseContainerTests

@synthesize baseContainer = _baseContainer;

- (void) setUp 
{
    [super setUp];
    
    self.baseContainer = [[ContactBaseContainer alloc] init];
}

- (void) testGetPhoneRegex
{
    NSString *phone1 = @"512-111-1111";
    
    NSString *result1 = [self.baseContainer getPhoneNumberDigitsRegex:phone1];
    
    assertThat(result1, equalTo(@"5121111111"));
    
    NSString *phone2 = @"(512) 222-2222";
    
    NSString *result2 = [self.baseContainer getPhoneNumberDigitsRegex:phone2];
    
    assertThat(result2, equalTo(@"5122222222"));
    
}

- (void) testAddDistinctUserToListWithNoDuplicates
{
    NSDictionary *contactEntries = [UnitTestDataFactory createContactEntriesWithStartingPhoneId:20];
    NSDictionary *loadedContactEntries = [UnitTestDataFactory loadContactEntries];
    NSDictionary *loadedEntries = [loadedContactEntries objectForKey:ContactLookupName];
    NSMutableArray *contactList = [contactEntries objectForKey:ContactArrayName];
    NSMutableDictionary *contactLookup = [contactEntries objectForKey:ContactLookupName];
    
    NSMutableDictionary *person = [loadedEntries objectForKey:@"Jack Doe"];
    
    [self.baseContainer addDistinctUserToList:contactList lookup:contactLookup person:person];
    
    assertThatInt([contactList count], equalToInt(3));
    assertThatInt([contactLookup count], equalToInt(3));
}

- (void) testAddDistinctUserToListWithSameNameDiffPhoneShouldMerge
{
    NSDictionary *contactEntries = [UnitTestDataFactory createContactEntriesWithStartingPhoneId:20];
    NSDictionary *loadedContactEntries = [UnitTestDataFactory loadContactEntries];
    NSDictionary *loadedEntries = [loadedContactEntries objectForKey:ContactLookupName];
    NSMutableArray *contactList = [contactEntries objectForKey:ContactArrayName];
    NSMutableDictionary *contactLookup = [contactEntries objectForKey:ContactLookupName];
    
    NSDictionary *person = [loadedEntries objectForKey:@"Jack Doe"];
    NSMutableDictionary *copyPerson = [UnitTestDataFactory createMutableCopyFromReadonly:person];
    NSDictionary *userA = [UnitTestDataFactory createUserA];
    [userA setValue:[copyPerson objectForKey:PersonPhoneList] forKey:PersonPhoneList];
    
    [self.baseContainer addDistinctUserToList:contactList lookup:contactLookup person:userA];
    
    assertThatInt([contactList count], equalToInt(2));
    assertThatInt([contactLookup count], equalToInt(2));
    
    NSDictionary *foundUserA = [contactLookup objectForKey:UserAName];
    NSDictionary *foundPhoneList = [foundUserA objectForKey:PersonPhoneList];
    assertThatInt([foundPhoneList count], equalToInt(5));
    
    // NSLog(@"foundPhoneList: %@", foundPhoneList);
}

@end











//
