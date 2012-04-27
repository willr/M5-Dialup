//
//  UnitTestDataFactory.m
//  Dialer
//
//  Created by William Richardson on 4/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "UnitTestDataFactory.h"
#import "Constants.h"
#import "UnitTestConstants.h"

@interface UnitTestDataFactory()

- (NSDictionary *)createEntryPhoneId:(int)phoneId 
                       phoneIdFormat:(NSString *)idFormat 
                         phoneNumber:(NSString *)phoneNumber 
                      phoneEntryList:(NSMutableDictionary *)phoneEntries;

- (NSDictionary *) createTestUserWithName:(NSString *)name 
                                  phoneId:(int *)phoneId 
                        phoneEntryFormats:(NSArray *)formats 
                         phoneEntryValues:(NSArray *)values;

- (NSDictionary *) createUserA:(int *)phoneId;

- (NSDictionary *) createUserB:(int *)phoneId;

@end

@implementation UnitTestDataFactory

- (NSDictionary *)createEntryPhoneId:(int)phoneId 
                       phoneIdFormat:(NSString *)idFormat 
                         phoneNumber:(NSString *)phoneNumber 
                      phoneEntryList:(NSMutableDictionary *)phoneEntries
{
    NSMutableDictionary *phoneNumberInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            [[NSNumber alloc] initWithInt:phoneId], PersonPhoneId, 
                            phoneNumber, PersonPhoneNumber, 
                            nil];

    [phoneEntries setObject:phoneNumberInfo forKey:[[NSString alloc] initWithFormat:idFormat, phoneId]];
     
    return phoneEntries;
}

- (NSDictionary *) createTestUserWithName:(NSString *)name 
                        phoneId:(int *)phoneId
              phoneEntryFormats:(NSArray *)formats 
               phoneEntryValues:(NSArray *)values
{
    NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
    // add the user name to the person object
    [person setObject:name forKey:PersonName];
    
    NSAssert([formats count] == [values count], @"Arrays should be equal as they are processed together");
    
    NSMutableDictionary *phoneEntriesList = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [formats count]; i++) {
        NSString *format = [formats objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        NSLog(@"using format: %@", format);
        NSLog(@"using value: %@", value);
        
        [self createEntryPhoneId:(*phoneId)++ phoneIdFormat:format phoneNumber:value phoneEntryList:phoneEntriesList];
    }
    
    [person setObject:phoneEntriesList forKey:PersonPhoneList];
    
    return person;
}

+ (NSDictionary *) createUserA
{
    UnitTestDataFactory *factory = [[self alloc] init];

    int phoneId = [UnitTestDataFactory standAloneUserPhoneId];
    int *phoneIdRef = malloc(sizeof(int));
    *phoneIdRef = phoneId;
    
    NSDictionary *user = [factory createUserA:phoneIdRef];
    
    // delete the factory
    [factory release];
    
    return user;
}

- (NSDictionary *) createUserA:(int *)phoneId
{
    
    NSArray *formats = [[NSArray alloc] initWithObjects:@"_$!<Home>!$__%d", @"iPhone__%d", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:UserAPhone1, UserAPhone2, nil];
    
    NSDictionary *person = [self createTestUserWithName:UserAName phoneId:phoneId phoneEntryFormats:formats phoneEntryValues:values];
    
    return person;
}

+ (NSDictionary *) createUserB
{
    UnitTestDataFactory *factory = [[self alloc] init];
    
    int phoneId = [UnitTestDataFactory standAloneUserPhoneId];
    int *phoneIdRef = malloc(sizeof(int));
    *phoneIdRef = phoneId;
    
    NSDictionary *user = [factory createUserB:phoneIdRef];
    
    // delete the factory
    [factory release];
    
    return user;
}

- (NSDictionary *) createUserB:(int *)phoneId
{
    NSArray *formats = [[NSArray alloc] initWithObjects:@"iPhone__%d", @"_$!<Home>!$__%d", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:UserBPhone1, UserBPhone2, nil];
    
    NSDictionary *person = [self createTestUserWithName:UserBName phoneId:phoneId phoneEntryFormats:formats phoneEntryValues:values];
    
    return person;
}

+ (NSDictionary *)createContactEntries
{
    int phoneId = 0;
    return [self createContactEntriesWithStartingPhoneId:phoneId];
    
}

+ (NSDictionary *)createContactEntriesWithStartingPhoneId:(int)phoneId
{
    UnitTestDataFactory *factory = [[self alloc] init];

    int *phoneIdRef = malloc(sizeof(int));
    *phoneIdRef = phoneId;
    
    // person UserA
    NSDictionary *userA = [factory createUserA:phoneIdRef];
    
    // person UserB
    NSDictionary *userB = [factory createUserB:phoneIdRef];
    
    NSMutableArray *contactList = [[NSMutableArray alloc] initWithObjects:userA, userB, nil];
    NSMutableDictionary *contactLookup = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userA, UserAName, userB, UserBName, nil];
    
    NSDictionary *contactInfo = [[NSDictionary alloc] initWithObjectsAndKeys:contactList, ContactArrayName, contactLookup, ContactLookupName, nil];
    
    // delete the factory
    [factory release];
    
    return contactInfo;
}

+ (NSDictionary *) loadContactEntries
{
    NSLog(@"Container FileName: %@", @"TestContactListContents.plist");
    NSArray *pathParts = [@"TestContactListContents.plist" componentsSeparatedByString:@"."];
    
    NSString *filePath = [[NSBundle bundleForClass:[UnitTestDataFactory class]] 
                          pathForResource:[pathParts objectAtIndex:0] 
                          ofType:[pathParts objectAtIndex:1]];
    
    NSLog(@"Res Path: %@", filePath);
    
    NSArray *contactList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    NSAssert(contactList != nil, @"Should not be null");
    NSAssert([contactList count] > 1, @"Should have at least on contact in the list");
    
    NSMutableDictionary *contactLookup = [[NSMutableDictionary alloc] init];
    for (NSDictionary *entry in contactList) {
        NSString *name = [entry objectForKey:PersonName];
        [contactLookup setObject:entry forKey:name];
    }
    
    NSDictionary *contactInfo = [[NSDictionary alloc] initWithObjectsAndKeys:contactList, ContactArrayName, contactLookup, ContactLookupName, nil];
    
    return contactInfo;
}

+ (NSUInteger) standAloneUserPhoneId
{
    return [[NSNumber numberWithUnsignedInt:9] unsignedIntValue];
}

+ (NSNumber *)getFirstFoundPhoneId:(NSDictionary *)person
{
    NSNumber *phoneId = nil;
    BOOL found = false;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSArray *phoneEntries = [phoneList allValues];
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
        phoneId = [phoneEntry objectForKey:PersonPhoneId];
        found = [phoneId isEqualToNumber:phoneId];
        
        if (found) {
            break;
        }
    }
    
    return phoneId;
}

+ (NSMutableDictionary *) createMutableCopyFromReadonly:(NSDictionary *)person
{
    NSMutableDictionary *copy = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *copyPhoneList = [[NSMutableDictionary alloc] init];
    NSDictionary *personPhoneList = [person objectForKey:PersonPhoneList];
    
    NSEnumerator *phoneListEnumerator = [personPhoneList keyEnumerator];
    for (NSString *key in phoneListEnumerator) {
        NSMutableDictionary *copyPhoneEntry = [[NSMutableDictionary alloc] init];
        
        NSDictionary *personPhoneEntry = [personPhoneList objectForKey:key];
        NSEnumerator *phoneEntryEnumerator = [personPhoneEntry keyEnumerator];
        for (NSString *entryKey in phoneEntryEnumerator) {
            [copyPhoneEntry setValue:[personPhoneEntry objectForKey:entryKey] forKey:entryKey];
        }
        
        [copyPhoneList setValue:copyPhoneEntry forKey:key];
        [copyPhoneEntry release];
    }
    
    [copy setValue:copyPhoneList forKey:PersonPhoneList];
    [copy setValue:[person objectForKey:PersonName] forKey:PersonName];
    
    [copyPhoneList release];
    
    return copy;
}

@end








