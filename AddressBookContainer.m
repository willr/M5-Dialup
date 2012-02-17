//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "AddressBookContainer.h"

#import <AddressBook/AddressBook.h>

@implementation AddressBookContainer

@synthesize tableViewData = _tableViewData, contactList = _contactList;

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        NSArray *section1 = [NSArray arrayWithObjects:@"Straight Lines", @"Curves", @"Shapes", nil];
        NSArray *section2 = [NSArray arrayWithObjects:@"Solid Fills", @"Gradient Fills", @"Image & Pattern Fills", nil];
        self.tableViewData = [NSDictionary dictionaryWithObjectsAndKeys:section1, @"Section1", section2, @"Section2", nil];
    }
    return self;
}

#pragma mark - AddressBook collection methods

- (void)getCopyFrom:(ABMultiValueRef)phones withKey:(const CFStringRef)key atIndex:(CFIndex)index placeInto:(NSMutableDictionary *)dict 
{
    NSString * phoneLabel = (NSString *)key;
    NSLog(@"key: %@, index: %ld", phoneLabel, index);
    NSString *copy = (NSString*)ABMultiValueCopyValueAtIndex(phones, index);
    [dict setObject:copy forKey:[NSString stringWithFormat:@"%@_%ld", phoneLabel, index]];
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

- (void)collectAddressBookInfo
{
    self.contactList = [[NSMutableArray alloc] init];
    
    ABAddressBookRef addressBook =  ABAddressBookCreate();
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
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
                [self getCopyFrom:phones withKey:phoneLabel atIndex:i placeInto:phoneList];
                CFRelease(phoneLabel);
            }
            [dOfPerson setObject:phoneList forKey:@"phoneList"];
            [self.contactList addObject:dOfPerson];
        }
        CFRelease(phones);
    }
    NSLog(@"array is %@", self.contactList);
    
    CFRelease(allPeople);
    // CFRelease(addressBook);
}

- (void)temp
{
    /*
     //For Email ids
     ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
     if(ABMultiValueGetCount(eMail) > 0) {
     [dOfPerson setObject:(NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
     }
     */
    
    /*
    if([mobileLabel isEqualToString:(NSString *)kABWorkLabel])
    {
        static NSString *mobilePhone = nil;
        if(mobilePhone == nil) mobilePhone = (NSString *)kABWorkLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:mobilePhone];
    }
    else if([mobileLabel isEqualToString:(NSString *)kABHomeLabel])
    {
        static NSString *mobilePhone = nil;
        if(mobilePhone == nil) mobilePhone = (NSString *)kABHomeLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:mobilePhone];
    }
    else if([mobileLabel isEqualToString:(NSString *)kABOtherLabel])
    {
        static NSString *mobilePhone = nil;
        if(mobilePhone == nil) mobilePhone = (NSString *)kABOtherLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:mobilePhone];
    }
    else if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
    {
        static NSString *mobilePhone = nil;
        if(mobilePhone == nil) mobilePhone = (NSString *)kABPersonPhoneMobileLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:mobilePhone];
    }
    else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
    {
        static NSString *iPhone = nil;
        if(iPhone == nil) iPhone = (NSString *)kABPersonPhoneIPhoneLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:iPhone];
        break ;
    } else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneMainLabel])
    {
        static NSString *mainPhone = nil;
        if(mainPhone == nil) mainPhone = (NSString *)kABPersonPhoneMainLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:mainPhone];
        break ;
    } else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneWorkFAXLabel])
    {
        static NSString *workPhone = nil;
        if(workPhone == nil) workPhone = (NSString *)kABPersonPhoneWorkFAXLabel;
        [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:workPhone];
        break ;
    }
     */
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
			return 2;
			break;
		case 1:
			return [self.contactList count];;
            // return 2;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)configureGeneralContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    static NSString *GeneralCellIdentifier = @"GeneralCell";
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GeneralCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GeneralCellIdentifier];
    }
    
    // id section = [self.tableViewData objectForKey:[NSString stringWithFormat:@"Section%d", indexPath.section + 1]];
    
    // set the data for the cell
	// NSString *rowLabel = [section objectAtIndex:indexPath.row];
    NSDictionary *person = [self.contactList objectAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:@"name"];
	cell.textLabel.text = rowLabel;
    // cell.textLabel.font = [cell.textLabel.font fontWithSize:12 ];
    cell.detailTextLabel.text = @"1";
    // cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:12];
    
    return cell;
}

- (NSString *)getPhoneLabelForDisplay:(NSString *)label
{
    NSRange foundRange = [label rangeOfString:@"work"
                                            options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"Work";
    }
    
    foundRange = [label rangeOfString:@"mobile"
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"Mobile";
    }
    
    foundRange = [label rangeOfString:@"iphone"
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"iPhone";
    }
    
    foundRange = [label rangeOfString:@"home"
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"Home";
    }
    
    return nil;
}

- (UITableViewCell *)configureFavoritesContactsCell:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath
{
    static NSString *FavoriteCellIdentifier = @"FavoriteCell";
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavoriteCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FavoriteCellIdentifier];
    }
    
    // id section = [self.tableViewData objectForKey:[NSString stringWithFormat:@"Section%d", indexPath.section + 1]];
    
    // set the data for the cell
	// NSString *rowLabel = [section objectAtIndex:indexPath.row];
    NSDictionary *person = [self.contactList objectAtIndex:indexPath.row];
    NSString *rowLabel = [person objectForKey:@"name"];
	cell.textLabel.text = rowLabel;
    // cell.textLabel.font = [cell.textLabel.font fontWithSize:12 ];
    NSDictionary *phones = [person objectForKey:@"phoneList"];
    
    [phones enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                                             {
                                                 NSLog(@"%@ has number %@", key, obj);
                                                 
                                                 cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@) %@", 
                                                                              [self getPhoneLabelForDisplay:key], obj];
                                             }];
    
    
    // cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:12];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    // Configure individual cells
	switch (indexPath.section) {
        case 0:
            cell = [self configureFavoritesContactsCell:tableView cellForRowAt:indexPath];
            break;
        case 1:
            cell = [self configureGeneralContactsCell:tableView cellForRowAt:indexPath];
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
			break;
		case 1:
			return @"Contact List";
			break;
		default:
			return nil;
			break;
	}
}

@end
