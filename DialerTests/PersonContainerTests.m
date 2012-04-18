//
//  Dialer - PersonContainerTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "PersonContainer.h"
#import "PersonContainer+PrivateMethods.h"

    // Collaborators
#import "CallButtonDelegate.h"
#import "PersonViewController.h"
#import "Constants.h"
#import "UnitTestConstants.h"
#import "ToggleImageControl.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "UnitTestDataFactory.h"


@interface PersonContainerTests : SenTestCase
{
    PersonContainer *_personContainer;
    
    NSDictionary *_contactLookup;
}

@property (strong, nonatomic) PersonContainer *personContainer;
@property (strong, nonatomic) NSDictionary *contactLookup;

@end


@implementation PersonContainerTests

@synthesize personContainer = _personContainer;
@synthesize contactLookup = _contactLookup;

- (void) setUp 
{
    [super setUp];
    
    self.personContainer = [[PersonContainer alloc] init];
    self.contactLookup = [[UnitTestDataFactory loadContactEntries] objectForKey:ContactLookupName];
    
    /*
     
    person.person = [self.addresses getPersonForPath:indexPath];
    person.callButtonDelegate = personController;
    person.favoritesListDelegate = self.addresses;
    
    */
    
    
    // self.personContainer.callButtonDelegate = [OCMockObject niceMockForProtocol: @protocol(CallButtonDelegate)];
}

- (void)testGetPersonNameAndPhoneNumberForUserB
{
    self.personContainer.person = [UnitTestDataFactory createUserB];
    NSLog(@"PersonContainer: %@", self.personContainer.person);
    
    // get retreieve the second phone number in the phone entries list
    NSDictionary *returnedPerson = [self.personContainer nameAndPhoneNumberAtIndex:1];
    
    assertThat([returnedPerson objectForKey:PersonName], equalTo(UserBName));
    assertThat([returnedPerson objectForKey:PersonPhoneNumber], equalTo(UserBPhone2));
}

- (void)testTitleForPhoneNumber
{
    NSDictionary *person = [self.contactLookup objectForKey:@"Jack Doe"];
    self.personContainer.person = person;
        
    NSString *found1 = [self.personContainer phoneTypeAtIndex:0];
    assertThat(found1, equalTo(@"Home"));
    NSString *found2 = [self.personContainer phoneTypeAtIndex:2];
    assertThat(found2, equalTo(@"Mobile"));
    NSString *found3 = [self.personContainer phoneTypeAtIndex:1];
    assertThat(found3, equalTo(@"iPhone"));
}



- (void) testToggleAddPhoneNumberAsFavorite
{
    NSDictionary *person = [self.contactLookup objectForKey:@"Jack Doe"];
    self.personContainer.person = person;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:1];
    NSNumber *phoneId = [phoneEntry objectForKey:PersonPhoneId];
    
    assertThatInt([phoneId intValue], equalToInt(8));
    
    ToggleImageControl *toggle = [[ToggleImageControl alloc] init];
    
    // set the toggled section = 1, which should be iPhone
    toggle.tag = 1;
    
    id favoritesListMock = [OCMockObject mockForProtocol: @protocol(FavoritesListDelegate)];
    self.personContainer.favoritesListDelegate = favoritesListMock;
    [[favoritesListMock expect] addFavorite:person phoneId:phoneId];
    
    [self.personContainer toggled:toggle];
    
    [favoritesListMock verify];
    
}

- (void) testToggleRemovePhoneNumberAsFavorite
{
    NSDictionary *person = [UnitTestDataFactory createUserB];
    self.personContainer.person = person;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSMutableDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:1];
    NSNumber *phoneId = [phoneEntry objectForKey:PersonPhoneId];
    [phoneEntry setObject:[NSNumber numberWithBool:true] forKey:PersonIsFavorite];
    
    assertThatInt([phoneId intValue], equalToInt(0));
    
    ToggleImageControl *toggle = [[ToggleImageControl alloc] init];
    
    // set the toggled section = 1, which should be iPhone
    toggle.tag = 1;
    
    id favoritesListMock = [OCMockObject mockForProtocol: @protocol(FavoritesListDelegate)];
    self.personContainer.favoritesListDelegate = favoritesListMock;
    [[favoritesListMock expect] removeFavorite:phoneId];
    
    [self.personContainer toggled:toggle];
    
    [favoritesListMock verify];
}

@end









