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
        self.contactList = [[[NSMutableArray alloc] init] autorelease];
        self.contactLookup = [[[NSMutableDictionary alloc] init] autorelease];
        self.abContainer = [[[AddressBookContainer alloc] init] autorelease];
    }
    return self;
}

- (NSUInteger)count
{
    return [self.contactList count];
}

- (NSDictionary *) personAtIndex:(NSUInteger)index
{
    return [self.contactList objectAtIndex:index];
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
    
    // NSLog(@"key: %@, index: %ld", phoneLabel, index);
    NSString *copy = (NSString*)[self.abContainer copyMultiValueValueAtIndex:phones index:index];
    [dict setObject:phoneAttribs forKey:[NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel, index]];
    [phoneAttribs setObject:copy forKey:PersonPhoneNumber];
    [phoneAttribs setObject:[NSNumber numberWithInteger:phoneId] forKey:PersonPhoneId];
    
    [phoneAttribs release];
    [copy release];
    [phoneLabel release];
}

- (BOOL)addUserName:(ABRecordRef)ref dOfPerson:(NSMutableDictionary *)dOfPerson
{
    NSString *firstName, *lastName;
    firstName = (NSString *)[self.abContainer copyRecordValue:ref propertyId:kABPersonFirstNameProperty];
    lastName  = (NSString *)[self.abContainer copyRecordValue:ref propertyId:kABPersonLastNameProperty];
    bool firstEmpty = false;
    bool lastEmpty = false;
    if (firstName == nil) {
        firstName = @"";
        firstEmpty = true;
    }
    if (lastName == nil) {
        lastName = @"";
        lastEmpty = true;
    }
    if (firstEmpty && lastEmpty) {
        NSLog(@"Empty user");
        return false;
    }
    
    [dOfPerson setObject:[NSString stringWithFormat:PersonNameFormat, firstName, lastName] forKey:PersonName];
    CFRelease(firstName);
    CFRelease(lastName);
    
    return true;
}

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

- (void)addContactPhones:(ABRecordRef)ref 
               dOfPerson:(NSMutableDictionary *)dOfPerson 
                 phoneId:(int *)phoneId
             contactList:(NSMutableArray *)contactList
           contactLookup:(NSMutableDictionary *)contactLookup
{
    //For username and surname
    ABMultiValueRef phones = (NSString*)[self.abContainer copyRecordValue:ref propertyId:kABPersonPhoneProperty];
    
    //For Phone number
    CFIndex phonesCount = [self.abContainer multiValueGetCount:phones];
    if(phonesCount > 0)
    {
        if (! [self addUserName:ref dOfPerson:dOfPerson])
        {
            CFRelease(phones);
            return;
        }
        
        NSMutableDictionary *phoneList = [NSMutableDictionary dictionary];
        NSLog(@"Num PhoneNums: %ld", phonesCount);
        for(CFIndex i = 0; i < phonesCount; i++) {
            NSString *phoneLabel = [self.abContainer copyMultiValueLabelAtIndex:phones index:i];
            NSLog(@"label: %@", phoneLabel);
            [self getCopyFrom:phones withKey:(CFStringRef)phoneLabel atIndex:i placeInto:phoneList havingPhoneId:*phoneId];
            (*phoneId)++;
            [phoneLabel release];
        }
        [dOfPerson setObject:phoneList forKey:PersonPhoneList];
        
        [self addDistinctUserToList:contactList 
                             lookup:contactLookup 
                             person:dOfPerson];
    }
    CFRelease(phones);
}

- (void)collectAddressBookInfo
{
    [self.abContainer addressBookCreate];
    
    CFArrayRef allPeople = (CFArrayRef)[self.abContainer copyAddressBookArrayOfAllPeople];
    CFIndex nPeople = [self.abContainer addressBookGetPersonCount];
    
    // id of the phoneNumber for selecting, deselecting as favorite
    int phoneId = 0;
    phoneId++;
    int addrCount = nPeople;
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson = [NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        if (nil == ref) {
            NSLog(@"Empty ref");
            continue;
        }
        
        [self addContactPhones:ref 
                     dOfPerson:dOfPerson 
                       phoneId:&phoneId 
                   contactList:self.contactList 
                 contactLookup:self.contactLookup];
    }
    NSAssert1(addrCount > 0, @"Failed to find any people in the current address book; Current Count %d", addrCount);
    // _favoriteList = [[NSMutableArray alloc] init];
    // [_favoriteList addObject:[self createFavoriteFromContactList:self.contactList contactIndex:0 phoneIndex:1]];
    // [_favoriteList addObject:[self createFavoriteFromContactList:self.contactList contactIndex:1 phoneIndex:0]];
    
    [self sortListByPersonName:self.contactList];
    
    NSLog(@"array is %@", self.contactList);
    
    CFRelease(allPeople);
    // CFRelease(addressBook);
}

@end









//