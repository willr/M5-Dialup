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
        self.contacts = [[[ContactListContainer alloc] init] autorelease];
        self.favorites = [[[FavoritePhoneContainer alloc] init] autorelease];
    }
    return self;
}

- (NSDictionary *)personAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *person;
    
    NSLog(@"Section: %d, Row: %d", indexPath.section, indexPath.row);
    switch (indexPath.section) {
        case 0:
            person = [self.favorites personAtIndex:indexPath.row];
            break;
        case 1:
            person = [self.contacts personAtIndex:indexPath.row];
            break;
        default:
            NSAssert(false, @"Invalid section number");
            break;
    }
    return person;
}

- (BOOL) favoritesModified
{
    return self.favorites.favoritesModified;
}

- (void)collectAddressBookInfo
{
    [self.contacts collectAddressBookInfo];
    [self.favorites loadSavedFavorites:self.contacts.contactLookup];
}

- (NSDictionary *)nameAndPhoneNumberAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UITableViewCell *)createGeneralContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    NSString *GeneralCellIdentifier = ContactListTableViewCellId;
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GeneralCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GeneralCellIdentifier] autorelease];
    }
    
    // set the data for the cell
	NSDictionary *person = [self.contacts personAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:PersonName];
	cell.textLabel.text = rowLabel;
    
    return cell;
}

- (UITableViewCell *)createFavoritesContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    static NSString *FavoriteCellIdentifier = @"FavoriteCell";
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavoriteCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FavoriteCellIdentifier] autorelease];
    }
    
    // set the data for the cell
    NSDictionary *person = [self.favorites personAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:PersonName];
	cell.textLabel.text = rowLabel;
    
    NSDictionary *phones = [person objectForKey:PersonPhoneList];
    [phones enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
         NSLog(@"%@ has number %@", key, obj);
         NSString *phoneNum = [obj objectForKey:PersonPhoneNumber];
         cell.detailTextLabel.text = [NSString stringWithFormat:PhoneNumberDisplayFormat, 
                                      [self.contacts getPhoneLabelForDisplay:key], phoneNum];
         *stop = YES;
    }];
    
    UIButton *callButton;
    callButton = [self configureCallButton:self.callButtonDelegate];
    cell.accessoryView = callButton;
    
    // [callButton release];    // button was auto-released
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
