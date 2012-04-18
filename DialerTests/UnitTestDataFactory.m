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
                                  phoneId:(int)phoneId 
                        phoneEntryFormats:(NSArray *)formats 
                         phoneEntryValues:(NSArray *)values;

- (NSDictionary *) createUserA:(int)phoneId;

- (NSDictionary *) createUserB:(int)phoneId;

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
                        phoneId:(int)phoneId 
              phoneEntryFormats:(NSArray *)formats 
               phoneEntryValues:(NSArray *)values
{
    NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
    // add the user name to the person object
    [person setObject:name forKey:PersonName];
    
    assert([formats count] == [values count]);
    
    NSMutableDictionary *phoneEntriesList = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [formats count]; i++) {
        NSString *format = [formats objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        NSLog(@"using format: %@", format);
        NSLog(@"using value: %@", value);
        
        [self createEntryPhoneId:phoneId phoneIdFormat:format phoneNumber:value phoneEntryList:phoneEntriesList];
    }
    
    [person setObject:phoneEntriesList forKey:PersonPhoneList];
    
    return person;
}

+ (NSDictionary *) createUserA
{
    UnitTestDataFactory *factory = [[self alloc] init];

    int phoneId = 0;
    
    NSDictionary *user = [factory createUserA:phoneId];
    
    // delete the factory
    [factory release];
    
    return user;
}

- (NSDictionary *) createUserA:(int)phoneId
{
    
    NSArray *formats = [[NSArray alloc] initWithObjects:@"_$!<Home>!$__%d", @"iPhone__%d", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:UserAPhone1, UserAPhone2, nil];
    
    NSDictionary *person = [self createTestUserWithName:UserAName phoneId:phoneId phoneEntryFormats:formats phoneEntryValues:values];
    
    return person;
}

+ (NSDictionary *) createUserB
{
    UnitTestDataFactory *factory = [[self alloc] init];
    
    int phoneId = 0;
    
    NSDictionary *user = [factory createUserB:phoneId];
    
    // delete the factory
    [factory release];
    
    return user;
}

- (NSDictionary *) createUserB:(int)phoneId
{
    NSArray *formats = [[NSArray alloc] initWithObjects:@"iPhone__%d", @"_$!<Home>!$__%d", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:UserBPhone1, UserBPhone2, nil];
    
    NSDictionary *person = [self createTestUserWithName:UserBName phoneId:phoneId phoneEntryFormats:formats phoneEntryValues:values];
    
    return person;
}

+ (NSDictionary *)createContactEntries
{
    UnitTestDataFactory *factory = [[self alloc] init];

    int phoneId = 0;
    
    // person UserA
    NSDictionary *userA = [factory createUserA:phoneId++];
    
    // person UserB
    NSDictionary *userB = [factory createUserB:phoneId++];
    
    NSArray *contactList = [[NSArray alloc] initWithObjects:userA, userB, nil];
    NSDictionary *contactLookup = [[NSDictionary alloc] initWithObjectsAndKeys:userA, UserAName, userB, UserBName, nil];
    
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
    
    assert(contactList != nil);
    assert([contactList count] > 1);
    
    NSMutableDictionary *contactLookup = [[NSMutableDictionary alloc] init];
    for (NSDictionary *entry in contactList) {
        NSString *name = [entry objectForKey:PersonName];
        [contactLookup setObject:entry forKey:name];
    }
    
    NSDictionary *contactInfo = [[NSDictionary alloc] initWithObjectsAndKeys:contactList, ContactArrayName, contactLookup, ContactLookupName, nil];
    
    return contactInfo;
}

@end








