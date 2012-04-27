//
//  Dialer - PersonDataSourceTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "PersonDataSource.h"

    // Collaborators
#import "UnitTestDataFactory.h"
#import "Constants.h"
#import "UnitTestConstants.h"
#import "PersonContainer.h"
#import "ToggleImageControl.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>
#import "OCMock.h"

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface PersonDataSourceTests : SenTestCase
{
    PersonDataSource    *_personDataSource;
    NSDictionary        *_contactLookup;
    
    id                  _personContainer;
    id                  _favoritesContainer;
}

@property (strong, nonatomic) PersonDataSource  *personDataSource;
@property (strong, nonatomic) NSDictionary      *contactLookup;
@property (strong, nonatomic) id                personContainerMock;
@property (strong, nonatomic) id                favortiesContainerMock;

@end

@implementation PersonDataSourceTests

@synthesize personDataSource        = _personDataSource;
@synthesize contactLookup           = _contactLookup;
@synthesize personContainerMock     = _personContainer;
@synthesize favortiesContainerMock  = _favoritesContainer;

- (void) setUp 
{
    [super setUp];
    
    self.personDataSource = [[PersonDataSource alloc] init];
    self.contactLookup = [[UnitTestDataFactory loadContactEntries] objectForKey:ContactLookupName];
    
    self.personContainerMock = [OCMockObject mockForClass:[PersonContainer class]];
    self.personDataSource.person = self.personContainerMock;
    self.favortiesContainerMock = [OCMockObject mockForClass:[FavoritePhoneContainer class]];
    self.personDataSource.favorites = self.favortiesContainerMock;
}

- (void)testNumberOfSectionsInTableViewEquals3
{
    NSUInteger num = [[NSNumber numberWithInt:3] unsignedIntValue];
    [[[self.personContainerMock stub] andReturnValue:OCMOCK_VALUE(num)] count];
    
    NSInteger retVal = [self.personDataSource numberOfSectionsInTableView:nil];
    
    [self.personContainerMock verify];
    
    assertThatInt(retVal, equalToInt(num));
}

- (void) testNumberOfRowsInSectionEquals1
{
    NSInteger num = [self.personDataSource tableView:nil numberOfRowsInSection:1];
    assertThatInt(num, equalToInt(1));
}

- (void) testToggleAddPhoneNumberAsFavorite
{
    NSNumber *phoneId = [NSNumber numberWithInt:9];
    
    ToggleImageControl *toggle = [[ToggleImageControl alloc] init];
    
    // set the toggled section = 1, which should be iPhone
    // this need to match phoneIdAtIndex below;
    toggle.tag = 1;
    
    BOOL fav = NO;
    [[[self.personContainerMock stub] andReturn:phoneId] phoneIdAtIndex:1];
    [[[self.favortiesContainerMock stub] andReturnValue:OCMOCK_VALUE(fav)] isFavorite:phoneId];
    
    NSDictionary *userA = [UnitTestDataFactory createUserA];
    [[[self.personContainerMock stub] andReturn:userA] person];
    [[self.favortiesContainerMock expect] addFavorite:userA phoneId:phoneId];
    
    [self.personDataSource toggled:toggle];
    
    [self.favortiesContainerMock verify];
    [self.personContainerMock verify];
}

- (void) testToggleRemovePhoneNumberAsFavorite
{
    NSNumber *phoneId = [NSNumber numberWithInt:9];
    
    ToggleImageControl *toggle = [[ToggleImageControl alloc] init];
    
    // set the toggled section = 1, which should be iPhone
    toggle.tag = 1;
    
    BOOL fav = YES;
    [[[self.personContainerMock stub] andReturn:phoneId] phoneIdAtIndex:1];
    [[[self.favortiesContainerMock stub] andReturnValue:OCMOCK_VALUE(fav)] isFavorite:phoneId];
    [[self.favortiesContainerMock expect] removeFavorite:phoneId];
    
    [self.personDataSource toggled:toggle];
    
    [self.favortiesContainerMock verify];
    [self.personContainerMock verify];
}

- (void) testTitleOfSectionHeaderIsiPhone
{
    NSString *phoneTypeName = @"iPhone";
    
    int sectionNum = 1;
    
    [[[self.personContainerMock stub] andReturn:phoneTypeName] phoneTypeAtIndex:sectionNum];
    
    NSString * title = [self.personDataSource tableView:nil titleForHeaderInSection:sectionNum];
    
    [self.personContainerMock verify];
    
    assertThat(title, equalTo(phoneTypeName));
}

- (void) testAccessoryButtonTappedToCallNumber
{
    NSUInteger indexes[2] = { 1, 3 };
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
    
    NSDictionary *result = [[NSDictionary alloc] init];
    [result setValue:@"result" forKey:@"key"];
    [[[self.personContainerMock expect] andReturn:result] nameAndPhoneNumberAtIndex:3];
    
    [self.personDataSource tableView:nil accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    [self.personContainerMock verify];
}

- (void) testCreateCellForRowAtIndexPathReturnContactListContact
{
    int section = 1;
    int row = 3;
    NSUInteger indexes[2] = { section, row };
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
    
    id tableView = [OCMockObject mockForClass:[UITableView class]];
    id tableCell = [OCMockObject niceMockForClass:[UITableViewCell class]];
    // id tableCellView = [OCMockObject mockForClass:[UIView class]];
    [[[tableView stub] andReturn:tableCell] dequeueReusableCellWithIdentifier:DetailListTableViewCellId];
    
    [[[self.personContainerMock stub] andReturn:[UnitTestDataFactory createUserB]] nameAndPhoneNumberAtIndex:section];
    
    // [[[tableCell stub] andReturn:tableCellView] contentView];
    // [[tableCellView expect] addSubview:[OCMArg any]];
    // [[tableCellView expect] addSubview:[OCMArg any]];
    
    NSNumber *phoneId = [NSNumber numberWithInt:9];
    BOOL fav = NO;
    [[[self.personContainerMock stub] andReturn:phoneId] phoneIdAtIndex:section];
    [[[self.favortiesContainerMock stub] andReturnValue:OCMOCK_VALUE(fav)] isFavorite:phoneId];
    
    [self.personDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    [tableView verify];
    [tableCell verify];
    
    [self.personContainerMock verify];
    [self.favortiesContainerMock verify];
}

- (void) testCreateCellForRowAtIndexPathReturnFavoriteListContact
{
    int section = 0;
    int row = 3;
    NSUInteger indexes[2] = { section, row };
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
    
    id tableView = [OCMockObject mockForClass:[UITableView class]];
    id tableCell = [OCMockObject niceMockForClass:[UITableViewCell class]];
    // id tableCellView = [OCMockObject mockForClass:[UIView class]];
    [[[tableView stub] andReturn:tableCell] dequeueReusableCellWithIdentifier:DetailListTableViewCellId];
    
    [[[self.personContainerMock stub] andReturn:[UnitTestDataFactory createUserB]] nameAndPhoneNumberAtIndex:section];
    
    // [[[tableCell stub] andReturn:tableCellView] contentView];
    // [[tableCellView expect] addSubview:[OCMArg any]];
    // [[tableCellView expect] addSubview:[OCMArg any]];
    
    NSNumber *phoneId = [NSNumber numberWithInt:9];
    BOOL fav = YES;
    [[[self.personContainerMock stub] andReturn:phoneId] phoneIdAtIndex:section];
    [[[self.favortiesContainerMock stub] andReturnValue:OCMOCK_VALUE(fav)] isFavorite:phoneId];
    
    [self.personDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    [tableView verify];
    [tableCell verify];
    
    [self.personContainerMock verify];
    [self.favortiesContainerMock verify];
    
}

@end






