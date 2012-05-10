//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import "AddressBookContainer.h"
#import "ContactListContainer.h"
#import "Constants.h"
#import "FavoritePhoneContainer.h"


@implementation ContactListContainer

@synthesize contactList = _contactList;
@synthesize contactLookup = _contactLookup;
@synthesize abContainer = _abContainer;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        
        // add all the raw data containers we are going to use
        _contactList = [[NSMutableArray alloc] init];
        _contactLookup = [[NSMutableDictionary alloc] init];
        _abContainer = [[AddressBookContainer alloc] init];
    }
    return self;
}

- (void) dealloc
{
    self.contactList = nil;
    self.contactLookup = nil;
    self.abContainer = nil;
    
    [super dealloc];
}

// all the users in the contact list
- (NSUInteger)count
{
    return [self.contactList count];
}

// get be the person at <index> position in the contact list
- (NSDictionary *) personAtIndex:(NSUInteger)index
{
    return [self.contactList objectAtIndex:index];
}

// build the name and phone entry dictionary for callling out and display in table cell, based on the position in the contact list
- (NSDictionary *) nameAndPhoneNumberAtIndex:(NSUInteger)pos
{
    NSDictionary *person = [self personAtIndex:pos];
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSString *phoneType = [[phoneList allKeys] objectAtIndex:0];
    NSDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:0];
    
    NSString *phoneNumberDigits = [phoneEntry objectForKey:PersonPhoneNumberDigits];
    if (phoneNumberDigits == nil) {
        phoneNumberDigits = [self getPhoneNumberDigitsRegex:[phoneEntry objectForKey:PersonPhoneNumber]];
        [phoneEntry setValue:phoneNumberDigits forKey:PersonPhoneNumberDigits];
    }
    
    return [self namePhoneNumberAndType:phoneEntry 
                                   name:[person objectForKey:PersonName] 
                              phoneType:[self getPhoneLabelForDisplay:phoneType] 
                            phoneDigits:phoneNumberDigits];
}

// retreive the person for the specified name and phoneId
- (NSDictionary *) personForName:(NSString *)name andPhoneId:(NSNumber *)phoneId
{
    // find the user by name
    NSDictionary *foundPerson = [self.contactLookup objectForKey:name];
    // verify it is the correct user, by checking via phoneId
    NSDictionary *phoneEntry = [self findPhoneEntryFromPerson:foundPerson forPhoneId:phoneId];
    
    // if we did not find a phoneEntry by matching phoneId nil our result, so we return nil for false
    if (phoneEntry == nil) {
        foundPerson = nil;
    }
    return foundPerson;
}

#pragma mark - AddressBook collection methods

// get a copy of the value from the addressbook entity specified by the <key> at <index> and place it into a collection with 
//      a <phoneId> attribute as specified 
- (void)getCopyFrom:(ABMultiValueRef)phones 
            withKey:(const CFStringRef)key 
            atIndex:(CFIndex)index 
          placeInto:(NSMutableDictionary *)dict 
      havingPhoneId:(int)phoneId
{
    // allocated dictionary (phone entry) to stored the phone information into, 
    //      all phone entry attributes will be stored in the this dictionary
    NSString * phoneLabel = (NSString *)key;
    NSMutableDictionary *phoneAttribs = [[NSMutableDictionary alloc] init];
    
    // NSLog(@"key: %@, index: %ld", phoneLabel, index);
    // copy the value out of the addressBook ref
    NSString *copy = (NSString*)[self.abContainer copyMultiValueValueAtIndex:phones index:index];
    // save the phone entry attributes dictionary created above into the passed in dictionary with a custom key, 
    //      based on retreived phone entry label and index
    [dict setObject:phoneAttribs forKey:[NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel, index]];
    // save the phone entry attributes in the phone entry dict
    [phoneAttribs setObject:copy forKey:PersonPhoneNumber];
    [phoneAttribs setObject:[NSNumber numberWithInteger:phoneId] forKey:PersonPhoneId];
    
    // release everything we created, as the collections should have retained the obejcts
    [phoneAttribs release];
    [copy release];
    [phoneLabel release];
}

// given a dictionary add the contact name to it, copying the values out of the addressbook ref
- (BOOL)addUserName:(ABRecordRef)ref dOfPerson:(NSMutableDictionary *)dOfPerson
{
    // get the firstname and lastname
    NSString *firstName, *lastName;
    firstName = (NSString *)[self.abContainer copyRecordValueAsString:ref propertyId:kABPersonFirstNameProperty];
    firstName = [firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    lastName  = (NSString *)[self.abContainer copyRecordValueAsString:ref propertyId:kABPersonLastNameProperty];
    lastName = [lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    bool firstEmpty = false;
    bool lastEmpty = false;
    
    // check for empty
    if (firstName == nil) {
        firstName = @"";
        firstEmpty = true;
    }
    if (lastName == nil) {
        lastName = @"";
        lastEmpty = true;
    }
    // if we have an empty name return false
    if (firstEmpty && lastEmpty) {
        NSLog(@"Empty user");
        return false;
    }
    
    // add the contact name to the given dictionary, release refs
    if ([firstName length] != 0 && [lastName length] != 0) {
        [dOfPerson setObject:[NSString stringWithFormat:PersonNameFormat, firstName, lastName] forKey:PersonName];
    } else if ([firstName length] != 0 && [lastName length] == 0) {
        [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:PersonName];
    } else {
        [dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:PersonName];
    }
    
    
    
    CFRelease(firstName);
    CFRelease(lastName);
    
    return true;
}

// sort the contact list by person name
- (void)sortListByPersonName:(NSMutableArray *)contactList
{
    // The results are likely to be shown to a user
    // Note the use of the localizedCaseInsensitiveCompare: selector
    NSSortDescriptor *nameDescriptor =
    [[[NSSortDescriptor alloc] initWithKey:PersonName
                                 ascending:YES
                                  selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
    [contactList sortUsingDescriptors:descriptors];
}

// add the phones of a contact to the contact list we are building up, iterate over all the phones a contact has
//  skipping them if they dont have any phones
- (void)addContactPhones:(ABRecordRef)ref 
               dOfPerson:(NSMutableDictionary *)dOfPerson 
                 phoneId:(int *)phoneId
             contactList:(NSMutableArray *)contactList
           contactLookup:(NSMutableDictionary *)contactLookup
{
    //For username and surname
    ABMultiValueRef phones = (NSString*)[self.abContainer copyRecordValueAsString:ref propertyId:kABPersonPhoneProperty];
    
    //get how many phone entries they have from the address book
    CFIndex phonesCount = [self.abContainer multiValueGetCount:phones];
    
    // if they have at least one, then process
    if(phonesCount > 0)
    {
        // add person's name, unless they dont have one, then skip
        if (! [self addUserName:ref dOfPerson:dOfPerson])
        {
            CFRelease(phones);
            return;
        }
        
        // create a dictionary to hold all the phone entries a person has
        NSMutableDictionary *phoneList = [NSMutableDictionary dictionary];
        // NSLog(@"Num PhoneNums: %ld", phonesCount);
        for(CFIndex i = 0; i < phonesCount; i++) {
            // copy the phone label of the address entry based on index, iterating through all phoneEntries
            NSString *phoneLabel = [self.abContainer copyMultiValueLabelAtIndex:phones index:i];
            // NSLog(@"label: %@", phoneLabel);
            // copy the phone entry info, (the value) portion of abref, and place the result in the phonelist
            [self getCopyFrom:phones withKey:(CFStringRef)phoneLabel atIndex:i placeInto:phoneList havingPhoneId:*phoneId];
            // iterate the phoneId, since we want phoneIds to be unique
            (*phoneId)++;
            [phoneLabel release];
        }
        // add the created phoneList to person dictionary
        [dOfPerson setObject:phoneList forKey:PersonPhoneList];
        // add the distinct phoneEntries to person entries if they already exist, else add the whole person
        [self addDistinctUserToList:contactList 
                             lookup:contactLookup 
                             person:dOfPerson];
    }
    CFRelease(phones);
}

// collect all the contact information
// this currently only works against the local address book, need to make it work against all addressbooks too
- (void)collectAddressBookInfo
{
    NSMutableArray *newContactList = [[NSMutableArray alloc] init];
    NSMutableDictionary *newContactLookup = [[NSMutableDictionary alloc] init];
    
    // dispatch this to a background thread, to handle the heavy load of processing the contacts
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // NSLog(@"collectAddressBookInfo::On async thread");
        
        [self collectAddressBookInfo:newContactList contactLookup:newContactLookup];
        
        // NSLog(@"-- self.contactList: async: %d", [newContactList count]);
        
        // dispatch back to the mainUI thread to handle the replacing of the containers
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // NSLog(@"collectAddressBookInfo::On main thread");
            
            // replace the old array and dictionary
            self.contactList = newContactList;
            self.contactLookup = newContactLookup;
            
            // NSLog(@"-- self.contactList: main: %d", [newContactList count]);
            
            // hmm how to get the tableView to redraw, must have a sticky bit..
            // ok push the notification via NSNotificationCenter.. 
            [[NSNotificationCenter defaultCenter] postNotificationName:ContactsReloaded
                                                                object:self
                                                              userInfo:nil];
        });
    });
}

// collect all the contact information, this is the method that will be execed async
// this currently only works against the local address book, need to make it work against all addressbooks too
- (void)collectAddressBookInfo:(NSMutableArray *)contactList
                 contactLookup:(NSMutableDictionary *)contactLookup
{
    // create the addressbook container
    [self.abContainer addressBookCreate];
    
    // // get an array of all the people, this is based on the default address book, (local)
    // CFArrayRef allPeople = (CFArrayRef)[self.abContainer copyAddressBookArrayOfAllPeople];
    // CFIndex nPeople = [self.abContainer addressBookGetPersonCount];
    
    int phoneId = 0;
    NSArray *allSources = [self.abContainer copyAddressBookArrayOfAllSources];
    for (int i = 0; i < [allSources count]; i++) {
        ABRecordRef source = [allSources objectAtIndex:i];
        
        ABRecordID sourceID = [self.abContainer recordGetRecordID:source];
        CFNumberRef sourceType = (CFNumberRef)[self.abContainer copyRecordValueAsNumber:source propertyId:kABSourceTypeProperty];
        CFStringRef sourceName = (CFStringRef)[self.abContainer copyRecordValueAsString:source propertyId:kABSourceNameProperty];
        NSLog(@"source id=%d type=%d name=%@", sourceID, [(NSNumber *)sourceType intValue], sourceName);
        CFRelease(sourceType);
        if (sourceName != NULL) CFRelease(sourceName); // some source names are NULL
        
        NSArray *sourcePeople = [self.abContainer copyAddressBookArrayOfAllPeopleInSource:source];
        // id of the phoneNumber for selecting, deselecting as favorite, is a uniqueId for each phoneEntry
        
        phoneId++;
        int addrCount = [sourcePeople count];
        for (int i=0;i < addrCount;i++) {
            NSMutableDictionary *dOfPerson = [NSMutableDictionary dictionary];
            // get person ref by index
            ABRecordRef ref = [sourcePeople objectAtIndex:i];
            if (nil == ref) {
                NSLog(@"Empty ref");
                continue;
            }
        
            // add the person and their phoneEntries to the contact list
            [self addContactPhones:ref 
                         dOfPerson:dOfPerson 
                           phoneId:&phoneId 
                       contactList:contactList 
                     contactLookup:contactLookup];
        }
        
        [sourcePeople release]; 
    }
    [allSources release];
    // NSAssert1(addrCount > 0, @"Failed to find any people in the current address book; Current Count %d", addrCount);
    
    // sort the contactList
    [self sortListByPersonName:contactList];
    
    // NSLog(@"array is %@", self.contactList);
    
    
}

@end









//