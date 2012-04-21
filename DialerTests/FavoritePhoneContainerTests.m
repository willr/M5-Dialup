//
//  Dialer - FavoriteListContainerTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "FavoritePhoneContainer.h"
#import "FavoritePhoneContainer+PrivateMethods.h"

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



@interface FavoritePhoneContainerTests : SenTestCase
{
    FavoritePhoneContainer *_favoriteContainer;
}

@property (strong, nonatomic) FavoritePhoneContainer *favoriteContainer;

@end

@implementation FavoritePhoneContainerTests

@synthesize favoriteContainer = _favoriteContainer;

- (void) setUp 
{
    [super setUp];
    
    self.favoriteContainer = [[FavoritePhoneContainer alloc] init];
}

- (void) testCount
{
    NSMutableArray *favs = self.favoriteContainer.favorites;
    
    NSDictionary *contactsLookup = [[UnitTestDataFactory createContactEntries] objectForKey:ContactLookupName];
    
    NSString *phoneIdFormat = @"_$!<Home>!$__%d";
    NSDictionary *userA = [contactsLookup objectForKey:UserAName];
    NSDictionary *userAPhoneEntry = [[userA objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 0]];
    NSNumber *userAPhoneId = [userAPhoneEntry objectForKey:PersonPhoneId];
    
    NSDictionary *userB = [contactsLookup objectForKey:UserBName];
    NSDictionary *userBPhoneEntry = [[userB objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 3]];
    NSNumber *userBPhoneId = [userBPhoneEntry objectForKey:PersonPhoneId];
    
    [self.favoriteContainer addFavorite:userA phoneId:userAPhoneId];
    
    [self.favoriteContainer addFavorite:userB phoneId:userBPhoneId];
    
    assertThatInteger([favs count], equalToInt(2));
}

- (NSDictionary *)getFavoritePhoneEntry:(NSDictionary *)person
{
    NSDictionary *foundPhoneEntry = nil;
    for (NSDictionary *phoneEntry in [[person objectForKey:PersonPhoneList] allValues]) {
        NSNumber *isFav = [phoneEntry objectForKey:PersonIsFavorite];
        if (isFav != nil && [isFav boolValue]) {
            foundPhoneEntry = phoneEntry;
            break;
        }
    }
    
    return foundPhoneEntry;
}

- (void) testAddFavoriteNoDuplicates
{
    NSDictionary *contactsLookup = [[UnitTestDataFactory createContactEntries] objectForKey:ContactLookupName];
        
    NSString *phoneIdFormat = @"_$!<Home>!$__%d";
    NSDictionary *userA = [contactsLookup objectForKey:UserAName];
    NSDictionary *userAPhoneEntry = [[userA objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 0]];
    NSNumber *userAPhoneId = [userAPhoneEntry objectForKey:PersonPhoneId];
    NSString *userAPhoneNumber = [userAPhoneEntry objectForKey:PersonPhoneNumber];
    
    NSDictionary *userB = [contactsLookup objectForKey:UserBName];
    NSDictionary *userBPhoneEntry = [[userB objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 3]];
    NSNumber *userBPhoneId = [userBPhoneEntry objectForKey:PersonPhoneId];
    NSString *userBPhoneNumber = [userBPhoneEntry objectForKey:PersonPhoneNumber];
    
    [self.favoriteContainer addFavorite:userA phoneId:userAPhoneId];
    [self.favoriteContainer addFavorite:userB phoneId:userBPhoneId];
    
    assertThatInteger([self.favoriteContainer count], equalToInt(2));
    
    NSArray *favs = self.favoriteContainer.favorites;
    NSDictionary *favA = [favs objectAtIndex:0];
    NSString *favAName = [favA objectForKey:PersonName];
    assertThat(favAName, equalTo(UserAName));
    
    NSDictionary *favB = [favs objectAtIndex:1];
    NSString *favBName = [favB objectForKey:PersonName];
    assertThat(favBName, equalTo(UserBName));
    
    NSDictionary *favAPhoneEntry = [self getFavoritePhoneEntry:favA];
    NSString *favAPhoneId = [favAPhoneEntry objectForKey:PersonPhoneId];
    NSString *favAPhoneNumber = [favAPhoneEntry objectForKey:PersonPhoneNumber];
    NSDictionary *favAPerson = [favAPhoneEntry objectForKey:FavoritePersonRefName];
    assertThat(favAPhoneId, equalTo(userAPhoneId));
    assertThat(favAPhoneNumber, equalTo(userAPhoneNumber));
    assertThat(favAPerson, notNilValue());
    assertThatBool([self.favoriteContainer isFavorite:userAPhoneId], equalToBool(YES));
    assertThatBool([self.favoriteContainer isFavorite:userAPhoneId withList:self.favoriteContainer.favorites], equalToBool(YES));
    
    NSDictionary *favBPhoneEntry = [self getFavoritePhoneEntry:favB];
    NSString *favBPhoneId = [favBPhoneEntry objectForKey:PersonPhoneId];
    NSString *favBPhoneNumber = [favBPhoneEntry objectForKey:PersonPhoneNumber];
    NSDictionary *favBPerson = [favBPhoneEntry objectForKey:FavoritePersonRefName];
    assertThat(favBPhoneId, equalTo(userBPhoneId));
    assertThat(favBPhoneNumber, equalTo(userBPhoneNumber));
    assertThat(favBPerson, notNilValue());
    assertThatBool([self.favoriteContainer isFavorite:userBPhoneId], equalToBool(YES));
    assertThatBool([self.favoriteContainer isFavorite:userBPhoneId withList:self.favoriteContainer.favorites], equalToBool(YES));
}

- (void) testAddFavoriteAddDuplicate
{
    NSDictionary *contactsLookup = [[UnitTestDataFactory createContactEntries] objectForKey:ContactLookupName];
    
    NSString *phoneIdFormat = @"_$!<Home>!$__%d";
    
    // user A
    NSDictionary *userA = [contactsLookup objectForKey:UserAName];
    // entry 0
    NSDictionary *userAPhoneEntry0 = [[userA objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 0]];
    NSNumber *userAPhoneId0 = [userAPhoneEntry0 objectForKey:PersonPhoneId];
    // NSString *userAPhoneNumber0 = [userAPhoneEntry0 objectForKey:PersonPhoneNumber];
    
    // entry 1
    NSDictionary *userAPhoneEntry1 = [[userA objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:@"iPhone__%d", 1]];
    NSNumber *userAPhoneId1 = [userAPhoneEntry1 objectForKey:PersonPhoneId];
    NSString *userAPhoneNumber1 = [userAPhoneEntry1 objectForKey:PersonPhoneNumber];
    
    // user B
    NSDictionary *userB = [contactsLookup objectForKey:UserBName];
    NSDictionary *userBPhoneEntry = [[userB objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 3]];
    NSNumber *userBPhoneId = [userBPhoneEntry objectForKey:PersonPhoneId];
    // NSString *userBPhoneNumber = [userBPhoneEntry objectForKey:PersonPhoneNumber];
    
    [self.favoriteContainer addFavorite:userA phoneId:userAPhoneId0];
    [self.favoriteContainer addFavorite:userB phoneId:userBPhoneId];
    [self.favoriteContainer addFavorite:userA phoneId:userAPhoneId1];
    [self.favoriteContainer addFavorite:userA phoneId:userAPhoneId0];
    
    // make sure only the third entry was added, not the forth
    assertThatInteger([self.favoriteContainer count], equalToInt(3));
    
    NSArray *favs = self.favoriteContainer.favorites;
    NSDictionary *favA = [favs objectAtIndex:2];
    NSString *favAName = [favA objectForKey:PersonName];
    assertThat(favAName, equalTo(UserAName));
    
    // check the third entry
    NSDictionary *favAPhoneEntry = [self getFavoritePhoneEntry:favA];
    NSString *favAPhoneId = [favAPhoneEntry objectForKey:PersonPhoneId];
    NSString *favAPhoneNumber = [favAPhoneEntry objectForKey:PersonPhoneNumber];
    NSDictionary *favAPerson = [favAPhoneEntry objectForKey:FavoritePersonRefName];
    assertThat(favAPhoneId, equalTo(userAPhoneId1));
    assertThat(favAPhoneNumber, equalTo(userAPhoneNumber1));
    assertThat(favAPerson, notNilValue());
    assertThatBool([self.favoriteContainer isFavorite:userAPhoneId1], equalToBool(YES));
    assertThatBool([self.favoriteContainer isFavorite:userAPhoneId1 withList:self.favoriteContainer.favorites], equalToBool(YES));
}

- (void) testRemoveFavorite
{
    NSDictionary *contactsLookup = [[UnitTestDataFactory createContactEntries] objectForKey:ContactLookupName];
    
    NSString *phoneIdFormat = @"_$!<Home>!$__%d";
    NSDictionary *userA = [contactsLookup objectForKey:UserAName];
    NSDictionary *userAPhoneEntry = [[userA objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 0]];
    NSNumber *userAPhoneId = [userAPhoneEntry objectForKey:PersonPhoneId];
    
    NSDictionary *userB = [contactsLookup objectForKey:UserBName];
    NSDictionary *userBPhoneEntry = [[userB objectForKey:PersonPhoneList] objectForKey:[NSString stringWithFormat:phoneIdFormat, 3]];
    NSNumber *userBPhoneId = [userBPhoneEntry objectForKey:PersonPhoneId];
    
    [self.favoriteContainer addFavorite:userA phoneId:userAPhoneId];
    [self.favoriteContainer addFavorite:userB phoneId:userBPhoneId];
    
    assertThatInteger([self.favoriteContainer count], equalToInt(2));
    
    NSArray *favs = self.favoriteContainer.favorites;
    NSDictionary *favA = [favs objectAtIndex:0];
    NSString *favAName = [favA objectForKey:PersonName];
    assertThat(favAName, equalTo(UserAName));
    assertThatBool([self.favoriteContainer isFavorite:userAPhoneId], equalToBool(YES));
    assertThatBool([self.favoriteContainer isFavorite:userAPhoneId withList:self.favoriteContainer.favorites], equalToBool(YES));
    
    NSDictionary *favB = [favs objectAtIndex:1];
    NSString *favBName = [favB objectForKey:PersonName];
    assertThat(favBName, equalTo(UserBName));
    assertThatBool([self.favoriteContainer isFavorite:userBPhoneId], equalToBool(YES));
    assertThatBool([self.favoriteContainer isFavorite:userBPhoneId withList:self.favoriteContainer.favorites], equalToBool(YES));
    
    [self.favoriteContainer removeFavorite:userAPhoneId];
    
    assertThatInteger([self.favoriteContainer count], equalToInt(1));
    
    NSDictionary *favBAgain = [favs objectAtIndex:0];
    NSString *favBAgainName = [favBAgain objectForKey:PersonName];
    assertThat(favBAgainName, equalTo(UserBName));
    assertThatBool([self.favoriteContainer isFavorite:userBPhoneId], equalToBool(YES));
    assertThatBool([self.favoriteContainer isFavorite:userBPhoneId withList:self.favoriteContainer.favorites], equalToBool(YES));
}

@end











//
