//
//  FavoritePhoneContainer.m
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "FavoritePhoneContainer.h"
#import "Constants.h"

@interface FavoritePhoneContainer ()

@end

@implementation FavoritePhoneContainer

@synthesize favoritesModified = _favoritesModified;
@synthesize favorites = _favorites;
@synthesize contactRef = _contactRef;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        self.favorites = [[[NSMutableArray alloc] init] autorelease];
        self.contactRef = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (NSUInteger)count
{
    return [self.favorites count];
}

- (void)removeFavorite:(NSNumber *)phoneId
{
    [self modifyFavoriteStatusOnPerson:[self.contactRef objectForKey:phoneId] phoneId:phoneId status:NO];
    [self modifyFavoriteStatus:self.favorites phoneId:phoneId status:NO];
    
    [self.favorites removeObject:[self personFromList:self.favorites phoneId:phoneId]];
    
    self.favoritesModified = true;
}

- (void)addFavorite:(NSDictionary *)person phoneId:(NSNumber *)phoneId
{
    if ([self isFavorite:phoneId]) {
        return;
    }
    
    NSInteger foundPhoneIndex = [self withPerson:person getPhoneIndexForPhoneId:phoneId];
    NSDictionary *favorite = [self createNewFavoriteFromContact:person phoneIndex:foundPhoneIndex];
    
    [self.favorites addObject:favorite];
    
    [self modifyFavoriteStatusOnPerson:person phoneId:phoneId status:YES];
    [self modifyFavoriteStatusOnPerson:favorite phoneId:phoneId status:YES];
    
    // NSLog(@"favorite: %@", favorite);
    
    _favoritesModified = true;
}
                              
- (NSInteger) withPerson:(NSDictionary *)person getPhoneIndexForPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    BOOL foundPhoneId = false;
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];

    NSInteger i = 0;
    for (NSString *phoneEntryKey in phoneList) {
        NSNumber *phoneIdToCheck = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId];
        found = [phoneId isEqualToNumber:phoneIdToCheck];
        
        if (found) {
            foundPhoneId = true;
            break;
        }
        i++;
    }
    
    return foundPhoneId ? i : -1;
}

- (BOOL)isFavorite:(NSNumber *) favoriteId
{
    BOOL found = [self isFavorite:favoriteId withList:self.favorites];
    
    return found;
}

- (BOOL)isFavorite:(NSNumber *) favoriteId withList:(NSArray *)list
{
    BOOL found = false;
    
    for (NSDictionary *person in list) {
        NSDictionary *phoneList = [person objectForKey:PersonPhoneList];

        NSNumber *phoneId;
        for (NSString *phoneEntryKey in phoneList) {
            phoneId = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId];
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

- (NSDictionary *)personAtIndex:(NSInteger)pos
{
    return [self.favorites objectAtIndex:pos];
}

- (NSNumber *) phoneIdAtIndex:(NSInteger)pos
{
    NSDictionary *person = [self personAtIndex:pos];
    
    // we can return the first found phoneId cause for Favorites, 
    //  we will only ever have on phoneEntry in the phoneList
    return [self getFirstFoundPhoneId:person];
}

- (NSDictionary *) nameAndPhoneNumberAtIndex:(NSUInteger)pos;
{
    NSDictionary *person = [self personAtIndex:pos];
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSString *phoneType = [[phoneList allKeys] objectAtIndex:0];
    NSDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:0];
    
    return [self namePhoneNumberAndType:phoneEntry name:[person objectForKey:PersonName] phoneType:[self getPhoneLabelForDisplay:phoneType]];
    
}

- (NSNumber *)getFirstFoundPhoneId:(NSDictionary *)person
{
    NSNumber *phoneId = nil;
    BOOL found = false;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    for (NSString *phoneEntryKey in phoneList) {
        phoneId = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId];
        found = phoneId != nil;
        
        if (found) {
            break;
        }
    }
    
    return phoneId;
}

- (NSDictionary *)personFromList:(NSArray *)list phoneId:(NSNumber *)phoneId
{
    NSDictionary *foundPerson = nil;
    NSDictionary *foundPhoneEntry = nil;
    
    for (NSDictionary *person in list) {
        foundPhoneEntry = [self findPhoneEntryFromPerson:person forPhoneId:phoneId];
        if (foundPhoneEntry != nil) {
            foundPerson = person;
        }
    }
    
    return foundPerson;
}

- (NSMutableDictionary *) getPhoneEntryFromList:(NSArray *)list forPhoneId:(NSNumber *)phoneId
{
    NSMutableDictionary *foundPhoneEntry = nil;
    
    for (NSDictionary *person in list) {
        foundPhoneEntry = [self findPhoneEntryFromPerson:person forPhoneId:phoneId];
        if (foundPhoneEntry != nil) {
            break;
        }
    }

    return foundPhoneEntry;
}
                            
- (NSMutableDictionary *)findPhoneEntryFromPerson:(NSDictionary *)person forPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    NSMutableDictionary *foundPhoneEntry = nil;
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];

    for (NSString *phoneEntryKey in phoneList) {
        NSMutableDictionary *phoneEntry = [phoneList objectForKey:phoneEntryKey];
        NSNumber *phoneIdToCheck = [phoneEntry objectForKey:PersonPhoneId];
        found = [phoneId isEqualToNumber:phoneIdToCheck];
        
        if (found) {
            foundPhoneEntry = phoneEntry;
            break;
        }
    }
    
    return foundPhoneEntry;
}

- (NSDictionary *)createNewFavoriteFromContact:(NSDictionary *)person 
                                    phoneIndex:(int)phoneIndex
{
    NSMutableDictionary *fav = [[[NSMutableDictionary alloc] init] autorelease];
    NSString * favName = [person objectForKey:PersonName];
    NSMutableDictionary *favPhoneList = [[NSMutableDictionary alloc] init];
    
    [fav setObject:favName forKey:PersonName];
    [fav setObject:favPhoneList forKey:PersonPhoneList];
    
    [favPhoneList setObject:[[[person objectForKey:PersonPhoneList] allValues] objectAtIndex:phoneIndex]                     
                     forKey:[[[person objectForKey:PersonPhoneList] allKeys] objectAtIndex:phoneIndex]];
    
    [favPhoneList release];
    
    // NSLog(@"createdFav: %@", fav);
    
    return fav;
}

- (NSDictionary *)createFavoriteFromContactList:(NSArray *)contactList 
                                   contactIndex:(int)contactIndex 
                                     phoneIndex:(int)phoneIndex
{
    NSDictionary *contact = [contactList objectAtIndex:contactIndex];
    
    return [self createNewFavoriteFromContact:contact 
                                   phoneIndex:phoneIndex];
}

- (BOOL)modifyFavoriteStatusOnPerson:(NSDictionary *)person 
                             phoneId:(NSNumber *)phoneId 
                              status:(BOOL)status
{
    BOOL found = false;
    
    NSMutableDictionary *phoneEntry = [self findPhoneEntryFromPerson:person forPhoneId:phoneId];
    if (phoneEntry != nil) {
        [phoneEntry setObject:[NSNumber numberWithBool:status] forKey:PersonIsFavorite];
        
        // this is for unfavoriting, as we only have the phoneId when unfavoriting
        if (status == true) {
            [self.contactRef  setObject:person forKey:phoneId];
        } else {
            [self.contactRef removeObjectForKey:FavoritePersonRefName];
        }
    }
    
    return found;
}

- (void)modifyFavoriteStatus:(NSArray *)list 
                     phoneId:(NSNumber *)phoneId 
                      status:(BOOL)status
{
    BOOL found = false;
    
    for (NSDictionary *person in list) {
        found = [self modifyFavoriteStatusOnPerson:person phoneId:phoneId status:status];
        
        if (found) {
            break;
        }
    }
}

- (BOOL)getFavoriteStatusFromList:(NSArray *)list phoneId:(NSNumber *)phoneId
{
    BOOL isFavorite = false;
    NSNumber *yesFavorite = [NSNumber numberWithBool:YES];
    
    NSDictionary *foundPhoneEntry = [self getPhoneEntryFromList:list forPhoneId:phoneId];
    if (foundPhoneEntry != nil) {
        NSNumber *isFavoriteStored = [foundPhoneEntry objectForKey:PersonIsFavorite];
        isFavorite = [isFavoriteStored isEqualToNumber:yesFavorite];
    }
    
    return isFavorite;
}

- (NSString *)favoritesFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FavoritesFileName];
    
    NSLog(@"Favorities File Path: %@", filePath);
    
    // NSAssert(filePath != nil, @"File path should not be nil");
    return filePath;
}

- (BOOL) validateFavorite:(NSDictionary *)favorite asContact:(NSMutableDictionary *)contact
{
    NSMutableDictionary *contactPhoneList = [contact objectForKey:PersonPhoneList];
    NSDictionary *favoritePhoneList = [favorite objectForKey:PersonPhoneList];
    BOOL found = false;
    
    NSEnumerator *favoritePhoneListEnumerator = [favoritePhoneList keyEnumerator];
    for (NSString *key in favoritePhoneListEnumerator) {
        NSDictionary *favoritePhoneEntry = [favoritePhoneList objectForKey:key];
        
        NSString *favoritePhoneNum = [favoritePhoneEntry objectForKey:PersonPhoneNumber];
        NSString *favoritePhoneDigits = [self getPhoneNumberDigitsRegex:favoritePhoneNum];
        
        found = [self isPhoneEntryMatchWithKey:key 
                               storedPhoneList:contactPhoneList 
                                newPhoneDigits:favoritePhoneDigits];
        if (found) {
            return found;
        }
    }
    
    return found;
}

- (void) loadSavedFavorites:(NSDictionary *)contactLookup
{
    NSString *filePath = [self favoritesFilePath];

    NSData *favoritesData = [NSData dataWithContentsOfFile:filePath];
    if (favoritesData == nil) {
        // just exit since there is no file to load
        return;
    }
    
    NSPropertyListFormat *format = NULL;
    NSError *error = nil;
    NSArray *serializedContactList = [NSPropertyListSerialization propertyListWithData:favoritesData 
                                                                     options:NSPropertyListMutableContainersAndLeaves 
                                                                      format:format 
                                                                       error:&error];
    
    for (NSMutableDictionary *favoritePerson in serializedContactList) {
        NSString *serializedPersonName = [favoritePerson objectForKey:PersonName];
        NSMutableDictionary *contactPerson = [contactLookup objectForKey:serializedPersonName];
        
        if([[favoritePerson objectForKey:PersonName] isEqual:serializedPersonName]) {
            BOOL isValid = [self validateFavorite:favoritePerson asContact:contactPerson];
            if (isValid) {
                [self.favorites addObject:favoritePerson];
            }
        }
    }
}

- (void) saveFavorites
{
    NSString *filePath = [self favoritesFilePath];
    
    NSLog(@"saveFavorites current Favorites: %@", self.favorites);
    
    // [self.favorites writeToFile:filePath atomically:YES];
    NSError *error = nil;
    NSData *favoritesData = [NSPropertyListSerialization dataWithPropertyList:self.favorites 
                                                                       format:NSPropertyListXMLFormat_v1_0 
                                                                      options:0 
                                                                        error:&error];
    if (error) {
        NSLog(@"Error Descr %@",error.localizedDescription);
        NSLog(@"Error Code %@",error.code);    
        NSLog(@"Error Domain %@",error.domain);
        return;
    }
    
    NSAssert([favoritesData length] != 0, @"serialization result is empty");
             
    [favoritesData writeToFile:filePath atomically:YES];
}

@end










// 