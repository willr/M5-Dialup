//
//  Dialer - ContactListDataSourceTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "ContactsDataSource.h"

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


@interface ContactListDataSourceTests : SenTestCase
{
    ContactsDataSource  *_contactDataSource;
    
    id                  _contactListContainer;
    id                  _favoriteContainer;
}

@property (strong, nonatomic) ContactsDataSource    *contactDataSource;
    
@property (strong, nonatomic) id                    contactListContainer;
@property (strong, nonatomic) id                    favoriteContainer;

@end


@implementation ContactListDataSourceTests

@synthesize contactDataSource       = _contactDataSource;
@synthesize contactListContainer    = _contactListContainer;
@synthesize favoriteContainer       = _favoriteContainer;

- (void) setUp 
{
    [super setUp];
    
    self.contactDataSource      = [[ContactsDataSource alloc] init];
    self.contactListContainer   = [OCMockObject mockForClass:[ContactListContainer class]];
    self.favoriteContainer      = [OCMockObject mockForClass:[FavoritePhoneContainer class]];
    
    self.contactDataSource.contacts = self.contactListContainer;
    self.contactDataSource.favorites = self.favoriteContainer;
}

- (void) testPersonAtIndexPath
{
    NSDictionary *userA = [UnitTestDataFactory createUserA];
    NSUInteger userARow = 3;
    [[[self.favoriteContainer expect] andReturn:userA] personAtIndex:userARow];
    
    // row 4 in section 0 (favorites)
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:userARow inSection:0];
    
    NSDictionary *userAFavorite = [self.contactDataSource personAtIndexPath:indexPath1];
    
    [self.favoriteContainer verify];
    
    assertThat(userAFavorite, notNilValue());
    assertThat([userAFavorite objectForKey:PersonName], equalTo(UserAName));
    
    
    NSDictionary *userB = [UnitTestDataFactory createUserB];
    NSUInteger userBRow = 2;
    [[[self.contactListContainer expect] andReturn:userB] personAtIndex:userBRow];
    
    // row 2 in section 1 (contactList)
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:userBRow inSection:1];
    
    NSDictionary *userBContact = [self.contactDataSource personAtIndexPath:indexPath2];
    
    [self.contactListContainer verify];
    
    assertThat(userBContact, notNilValue());
    assertThat([userBContact objectForKey:PersonName], equalTo(UserBName));
    
}

@end










// 

