//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <AddressBook/AddressBook.h>

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
    if (self) {
        // Custom initialization
        
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
    NSString *copy = (NSString*)[self.abContainer multiValueCopyValueAtIndex:phones index:index];
    [dict setObject:phoneAttribs forKey:[NSString stringWithFormat:UniquePhoneIdentifierFormat, phoneLabel, index]];
    [phoneAttribs setObject:copy forKey:PersonPhoneNumber];
    [phoneAttribs setObject:[NSNumber numberWithInteger:phoneId] forKey:PersonPhoneId];
    
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
    
    [dOfPerson setObject:[NSString stringWithFormat:PersonNameFormat, firstName, lastName] forKey:PersonName];
    CFRelease(firstName);
    CFRelease(lastName);
    
    return true;
}



- (void)collectAddressBookInfo
{
    self.contactList = [[[NSMutableArray alloc] init] autorelease];
    self.contactLookup = [[[NSMutableDictionary alloc] init] autorelease];
    
    ABAddressBookRef addressBook =  [self.abContainer addressBookCreate];
    
    CFArrayRef allPeople = [self.abContainer addressBookCopyArrayOfAllPeople:addressBook];
    CFIndex nPeople = [self.abContainer addressBookGetPersonCount:addressBook];
    
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
        
        //For username and surname
        ABMultiValueRef phones = (NSString*)[self.abContainer recordCopyValue:ref propertyId:kABPersonPhoneProperty];
        
        //For Phone number
        CFIndex phonesCount = [self.abContainer multiValueGetCount:phones];
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
                NSString *phoneLabel = [self.abContainer multiValueCopyLabelAtIndex:phones index:i];
                NSLog(@"label: %@", phoneLabel);
                [self getCopyFrom:phones withKey:(CFStringRef)phoneLabel atIndex:i placeInto:phoneList havingPhoneId:phoneId++];
                [phoneLabel release];
            }
            [dOfPerson setObject:phoneList forKey:PersonPhoneList];
            
            [self addDistinctUserToList:self.contactList 
                                 lookup:self.contactLookup 
                                 person:dOfPerson];
        }
        CFRelease(phones);
    }
    NSAssert(addrCount > 0, @"Failed to find any people in the current address book");
    // _favoriteList = [[NSMutableArray alloc] init];
    // [_favoriteList addObject:[self createFavoriteFromContactList:self.contactList contactIndex:0 phoneIndex:1]];
    // [_favoriteList addObject:[self createFavoriteFromContactList:self.contactList contactIndex:1 phoneIndex:0]];
    
    // The results are likely to be shown to a user
    // Note the use of the localizedCaseInsensitiveCompare: selector
    NSSortDescriptor *nameDescriptor =
        [[[NSSortDescriptor alloc] initWithKey:PersonName
                                     ascending:YES
                                      selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
    [self.contactList sortUsingDescriptors:descriptors];
    
    NSLog(@"array is %@", self.contactList);
    
    CFRelease(allPeople);
    // CFRelease(addressBook);
    
}




@end
