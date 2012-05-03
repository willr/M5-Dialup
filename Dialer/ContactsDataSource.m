//
//  ContactsDataSource.m
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ContactsDataSource.h"
#import "FavoritePhoneContainer.h"
#import "Constants.h"

@implementation ContactsDataSource

@synthesize contacts = _contacts;
@synthesize favorites = _favorites;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        
        // create the two containers for this dataSource
        // contacts is a list of all contacts on the phone
        // favorites is only those selected as "favorite"
        self.contacts = [[[ContactListContainer alloc] init] autorelease];
        self.favorites = [[[FavoritePhoneContainer alloc] init] autorelease];
    }
    return self;
}

- (void) dealloc
{
    self.contacts = nil;
    self.favorites = nil;
    
    [super dealloc];
}

// common method to retrieve person at the specified row, will 
//      delegate to respective container for actual person data
// we should return the actual full contact entry and not the truncated favorite entry
- (NSDictionary *)personAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *person;
    
    // NSLog(@"Section: %d, Row: %d", indexPath.section, indexPath.row);
    switch (indexPath.section) {
        case 0:
        {
            // we should return the actual full contact entry and not the truncated favorite entry
            NSDictionary *favPerson = [self.favorites personAtIndex:indexPath.row];
            NSNumber *phoneId = [self.favorites getFirstFoundPhoneId:favPerson];
            person = [self.contacts personForName:[favPerson objectForKey:PersonName] andPhoneId:phoneId];
            break;
        }
        case 1:
            person = [self.contacts personAtIndex:indexPath.row];
            break;
        default:
            NSAssert(false, @"Invalid section number");
            break;
    }
    return person;
}

// allows the viewController to see when the favorites have been modified and reload the tableview
- (BOOL) favoritesModified
{
    return self.favorites.favoritesModified;
}

// starter method for loading the addressBook.  Should take place off the UI Thread, as this is a heavy operation
- (void)collectAddressBookInfo
{
    // load contacts
    [self.contacts collectAddressBookInfo];
    
    // load saved favorites, we need to pass in the current dictionary of contacts, as we only display as favorites those
    //      names and numbers that are still valid contacts
    [self.favorites loadSavedFavorites:self.contacts.contactLookup];
}

// common method to retrieve the name and phoneEntry info for actually placing a call with the system
- (NSDictionary *)nameAndPhoneNumberAtIndexPath:(NSIndexPath *)indexPath
{
    // based on section delegate to the correct container
    NSDictionary *results = nil;
    switch (indexPath.section) {
        case 0:
            results = [self.favorites nameAndPhoneNumberAtIndex:indexPath.row];
            break;
        case 1:
            results = [self.contacts nameAndPhoneNumberAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    return results;
}

#pragma mark - TableViewDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // section 0: Favorites
    // section 1: Contacts list
    
    // will return the number of rows per section
    switch (section) {
		case 0:
			return [self.favorites count];
			break;
		case 1:
			return [self.contacts count];
            // return 2;
			break;
		default:
			return 0;
			break;
	}
}

// these are cells which are the general contacts, meaning they will be displayed just as the contact name
- (UITableViewCell *)createGeneralContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactListTableViewCellId];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactListTableViewCellId] autorelease];
    }
    
    // set the data for the cell, retrieve from contactListContainer, (general contact)
	NSDictionary *person = [self.contacts personAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:PersonName];
	cell.textLabel.text = rowLabel;
    
    return cell;
}

// thise are cells which are going to be listed as favorites, should include, name, phone type, and phone number
- (UITableViewCell *)createFavoritesContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavoritesListTableViewCellId];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FavoritesListTableViewCellId] autorelease];
        
        // add the callButton to the accessoryView
        UIButton *callButton;
        // set target of selector to viewController for handling call
        callButton = [self configureCallButton:self.callButtonDelegate];
        
        // this will invalidate the accessoryButtonTappedForRowWhithIndexPath method being called as we are setting the view
        cell.accessoryView = callButton;
    }
    
    // set the data for the cell, retrieve from favoritesContainer
    NSDictionary *person = [self.favorites personAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:PersonName];
	cell.textLabel.text = rowLabel;
    
    // get the phone type and phone number for the detailText
    NSDictionary *phones = [person objectForKey:PersonPhoneList];
    [phones enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
         // NSLog(@"%@ has number %@", key, obj);
         NSString *phoneNum = [obj objectForKey:PersonPhoneNumber];
         cell.detailTextLabel.text = [NSString stringWithFormat:PhoneNumberDisplayFormat, 
                                      [self.contacts getPhoneLabelForDisplay:key], phoneNum];
         *stop = YES;
    }];
    
    return cell;
}

// UITableViewDataSource delegate common method for getting the cell for an indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set Favorites to notModified, as we are going display all current favorites nows
    self.favorites.favoritesModified = false;
    
    UITableViewCell *cell = nil;
    
    // Configure individual cells
	switch (indexPath.section) {
        case 0:
            cell = [self createFavoritesContactsCell:tableView cellForRowAt:indexPath];
            break;
        case 1:
            cell = [self createGeneralContactsCell:tableView cellForRowAt:indexPath];
            break;
        default:
            break;
    }
    
    return cell;
}

// get the header titles for each of the two sections
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // section 0: Favorites
    // section 1: Contacts list
    
    // return the titles of each section
    switch (section) {
		case 0:
			return FavoritesSectionName;
		case 1:
			return GeneralContactsSectionName;
		default:
			return nil;
			break;
	}
}


@end
