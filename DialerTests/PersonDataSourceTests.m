//
//  Dialer - PersonDataSourceTests.m
//  Copyright 2012 CodeSpan Technologies. All rights reserved.
//
//  Created by: William Richardson
//

    // Class under test
#import "PersonDataSource.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
//#define HC_SHORTHAND
//#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface PersonDataSourceTests : SenTestCase
{
    PersonContainer *_personContainer;
    
    NSDictionary *_contactLookup;
}

@property (strong, nonatomic) PersonContainer *personContainer;
@property (strong, nonatomic) NSDictionary *contactLookup;

@end


@implementation PersonDataSourceTests

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

- (void)testNumberOfSectionsInTableViewEquals3
{
    NSDictionary *person = [self.contactLookup objectForKey:@"Jack Doe"];
    self.personContainer.person = person;
    
    NSInteger num = [self.personContainer numberOfSectionsInTableView:nil];
    
    assertThatInt(num, equalToInt(3));
    
}

- (void) testNumberOfRowsInSectionEquals1
{
    NSInteger num = [self.personContainer tableView:nil numberOfRowsInSection:1];
    assertThatInt(num, equalToInt(1));
}

@end
