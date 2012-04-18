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
    PersonContainer         *_personContainer;
    FavoritePhoneContainer  *_favoritesContainer;
    NSDictionary            *_contactLookup;
}

@property (strong, nonatomic) PersonContainer           *personContainer;
@property (strong, nonatomic) FavoritePhoneContainer    *favoritesContainer;
@property (strong, nonatomic) NSDictionary              *contactLookup;

@end


@implementation PersonContainerTests

@synthesize personContainer =       _personContainer;
@synthesize contactLookup =         _contactLookup;
@synthesize favoritesContainer =    _favoritesContainer;

- (void) setUp 
{
    [super setUp];
    
    self.personContainer = [[PersonContainer alloc] init];
    self.contactLookup = [[UnitTestDataFactory loadContactEntries] objectForKey:ContactLookupName];
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

- (void) testPhoneEntryAtIndexEqualsUserBiPhone
{
    NSDictionary *userB = [UnitTestDataFactory createUserB];
    self.personContainer.person = userB;
    NSLog(@"UserB entry: %@", userB);
    
    NSDictionary *found = [self.personContainer phoneEntryAtIndex:0];
    NSLog(@"PhoneEntryAtIndex entry: %@", found);
    
    NSNumber *phoneId = [found objectForKey:PersonPhoneId];
    assertThat(phoneId, notNilValue());
    assertThatInt([phoneId unsignedIntValue], equalToInt([UnitTestDataFactory standAloneUserPhoneId]));
    NSString *phoneNumber = [found objectForKey:PersonPhoneNumber];
    assertThat(phoneNumber, equalTo(UserBPhone1));
    
}

- (void) testCountOfPhoneEntries
{
    NSDictionary *person = [self.contactLookup objectForKey:@"Jack Doe"];
    self.personContainer.person = person;
    
    NSUInteger retCount = [self.personContainer count];
    
    assertThatInteger(retCount, equalToInteger(3));
}

- (void) testPhoneIdAtIndex
{
    NSDictionary *person = [self.contactLookup objectForKey:@"Jack Doe"];
    self.personContainer.person = person;
    
    NSNumber *found1 = [self.personContainer phoneIdAtIndex:0];
    assertThatInt([found1 intValue], equalToInt(9));
    NSNumber *found2 = [self.personContainer phoneIdAtIndex:1];
    assertThatInt([found2 intValue], equalToInt(8));
    NSNumber *found3 = [self.personContainer phoneIdAtIndex:2];
    assertThatInt([found3 intValue], equalToInt(7));
}


@end









