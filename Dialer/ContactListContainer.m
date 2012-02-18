//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ContactListContainer.h"

#import <AddressBook/AddressBook.h>

@implementation ContactListContainer

@synthesize contactList = _contactList, favoritesModified = _favoritesModified;

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - FavoritesListDelegate methods

- (void)removeFavorite:(NSNumber *)phoneId
{
    // [_favoriteList removeObjectAtIndex:[index intValue]];
    
    [self modifyFavoriteStatus:_favoriteList phoneId:phoneId status:NO];
    [self modifyFavoriteStatus:_contactList phoneId:phoneId status:NO];
    
    _favoritesModified = true;
}


- (void)addFavorite:(NSDictionary *)personPhone
{
    [_favoriteList addObject:personPhone];
    
    NSNumber *phoneId;
    
    phoneId = [self getFirstFoundPhoneId:personPhone];    
    assert(phoneId != nil);
    
    [self modifyFavoriteStatus:_favoriteList phoneId:phoneId status:NO];
    [self modifyFavoriteStatus:_contactList phoneId:phoneId status:NO];
    
    _favoritesModified = true;
}


- (BOOL)isFavorite:(NSNumber *) favoriteId
{
    BOOL found = false;
    
    for (NSDictionary *person in _favoriteList) {
        NSDictionary *phoneList = [person objectForKey:@"phoneList"];
        NSArray *phoneEntries = [phoneList allValues];
        NSNumber *phoneId;
        for (NSDictionary *phoneEntry in phoneEntries) {
            phoneId = [phoneEntry objectForKey:@"phoneId"];
            found = [phoneId isEqualToNumber:favoriteId];
            if (found) {
                break;
            }
        }
        
        if (found) {
            break;
        }
    }
    
    return found;
}


#pragma mark - AddressBook collection methods

- (void)getCopyFrom:(ABMultiValueRef)phones 
            withKey:(const CFStringRef)key 
            atIndex:(CFIndex)index 
          placeInto:(NSMutableDictionary *)dict 
      havingPhoneId:(int)phoneId
{
    NSString * phoneLabel = (NSString *)key;
    NSMutableDictionary *phoneAttribs = [[NSMutableDictionary alloc] init];
    
    NSLog(@"key: %@, index: %ld", phoneLabel, index);
    NSString *copy = (NSString*)ABMultiValueCopyValueAtIndex(phones, index);
    [dict setObject:phoneAttribs forKey:[NSString stringWithFormat:@"%@_%ld", phoneLabel, index]];
    [phoneAttribs setObject:copy forKey:@"phoneNumber"];
    [phoneAttribs setObject:[NSNumber numberWithInteger:phoneId] forKey:@"phoneId"];
    
    [phoneAttribs release];
    [copy release];
    [phoneLabel release];
}

- (BOOL)addUserName:(ABRecordRef)ref dOfPerson:(NSMutableDictionary *)dOfPerson
{
    CFStringRef firstName, lastName;
    firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
    lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
    bool firstEmpty = false;
    bool lastEmpty = false;
    if (firstName == nil) {
        firstName = (CFStringRef)@"";
        firstEmpty = true;
    }
    if (lastName == nil) {
        lastName = (CFStringRef)@"";
        lastEmpty = true;
    }
    if (firstEmpty && lastEmpty) {
        NSLog(@"Empty user");
        return false;
    }
    
    [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
    CFRelease(firstName);
    CFRelease(lastName);
    
    return true;
}


- (NSDictionary *)createFavoriteFromContactList:(NSArray *)contactList 
                                   contactIndex:(int)contactIndex 
                                     phoneIndex:(int)phoneIndex
{
    NSDictionary *contact = [self.contactList objectAtIndex:contactIndex];
    
    return [self createNewFavoriteFromContact:contact 
                                 contactIndex:contactIndex 
                                   phoneIndex:phoneIndex];
}

- (void)collectAddressBookInfo
{
    self.contactList = [[[NSMutableArray alloc] init] autorelease];
    
    ABAddressBookRef addressBook =  ABAddressBookCreate();
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    // id of the phoneNumber for selecting, deselecting as favorite
    int phoneId = 0;
    phoneId++;
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson = [NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        if (nil == ref) {
            NSLog(@"Empty ref");
            continue;
        }
        
        //For username and surname
        ABMultiValueRef phones = (NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty);
        
        //For Phone number
        CFIndex phonesCount = ABMultiValueGetCount(phones);
        if(phonesCount > 0)
        {
            if (! [self addUserName:ref dOfPerson:dOfPerson])
            {
                CFRelease(phones);
                continue;
            }
            
            NSMutableDictionary *phoneList = [NSMutableDictionary dictionary];
            NSLog(@"Num PhoneNums: %ld", phonesCount);
            for(CFIndex i = 0; i < phonesCount; i++) {
                CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phones, i);
                NSLog(@"label: %@", phoneLabel);
                [self getCopyFrom:phones withKey:phoneLabel atIndex:i placeInto:phoneList havingPhoneId:phoneId++];
                CFRelease(phoneLabel);
            }
            [dOfPerson setObject:phoneList forKey:@"phoneList"];
            [self.contactList addObject:dOfPerson];
        }
        CFRelease(phones);
    }
    NSLog(@"array is %@", self.contactList);
    
    CFRelease(allPeople);
    // CFRelease(addressBook);  // Dont know why if I release this, it crashes... 
    
    _favoriteList = [[NSMutableArray alloc] init];
    [_favoriteList addObject:[self createFavoriteFromContactList:self.contactList contactIndex:0 phoneIndex:1]];
    [_favoriteList addObject:[self createFavoriteFromContactList:self.contactList contactIndex:1 phoneIndex:0]];
    
}

- (NSDictionary *)getPersonForPath:(NSIndexPath *)indexPath
{
    return [self.contactList objectAtIndex:indexPath.row];
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
			return [_favoriteList count];
			break;
		case 1:
			return [self.contactList count];
            // return 2;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)createGeneralContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    static NSString *GeneralCellIdentifier = @"GeneralCell";
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GeneralCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GeneralCellIdentifier] autorelease];
    }
    
    // set the data for the cell
	NSDictionary *person = [self.contactList objectAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:@"name"];
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
    NSDictionary *person = [_favoriteList objectAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:@"name"];
	cell.textLabel.text = rowLabel;
    
    NSDictionary *phones = [person objectForKey:@"phoneList"];
    [phones enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                                             {
                                                 NSLog(@"%@ has number %@", key, obj);
                                                 NSString *phoneNum = [obj objectForKey:@"phoneNumber"];
                                                 cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@) %@", 
                                                                              [self getPhoneLabelForDisplay:key], phoneNum];
                                                 *stop = YES;
                                             }];
    
    UIButton *callButton;
    callButton = [self configureCallButton];
    cell.accessoryView = callButton;
    
    // [callButton release];    // button was auto-released
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _favoritesModified = false;
    
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
			return @"Favorites";
		case 1:
			return @"Contact List";
		default:
			return nil;
			break;
	}
}

@end
