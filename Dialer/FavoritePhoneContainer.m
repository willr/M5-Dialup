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

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.favorites = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)count
{
    return [self.favorites count];
}

- (void)removeFavorite:(NSNumber *)phoneId
{
    NSDictionary *phoneEntry = [self getPhoneEntryFromList:self.favorites forPhoneId:phoneId];
    NSDictionary *personRef = [phoneEntry objectForKey:FavoritePersonRefName];
    if (personRef == nil) {
        NSString *errorText = [NSString stringWithFormat:@"PersonRef cannot be nil, phoneId: %d", [phoneId intValue]];
        NSAssert(personRef == nil, errorText);
    }
    
    [self modifyFavoriteStatusOnPerson:personRef phoneId:phoneId status:NO];
    [self modifyFavoriteStatus:self.favorites phoneId:phoneId status:NO];
    
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
    
    _favoritesModified = true;
}
                              
- (NSInteger) withPerson:(NSDictionary *)person getPhoneIndexForPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    BOOL foundPhoneId = false;
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSArray *phoneEntries = [phoneList allValues];
    NSInteger i = 0;
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
        NSNumber *phoneIdToCheck = [phoneEntry objectForKey:PersonPhoneId];
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
    BOOL found = false;
    
    for (NSDictionary *person in self.favorites) {
        NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
        NSArray *phoneEntries = [phoneList allValues];
        NSNumber *phoneId;
        for (NSDictionary *phoneEntry in phoneEntries) {
            phoneId = [phoneEntry objectForKey:PersonPhoneId];
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

- (NSDictionary *)personFromList:(NSArray *)list phoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    NSDictionary *foundPerson = nil;
    for (NSDictionary *person in list) {
        NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
        for (NSDictionary *phoneEntry in [phoneList allValues]) {
            NSNumber *foundPhoneId = [phoneEntry objectForKey:PersonPhoneId];
            found = [foundPhoneId isEqualToNumber:phoneId];
            if (found) {
                foundPerson = person;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    
    return foundPerson;
}

- (NSDictionary *) getPhoneEntryFromList:(NSArray *)list forPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    NSDictionary *foundPhoneEntry = nil;
    
    for (NSDictionary *person in list) {
        NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
        NSArray *phoneEntries = [phoneList allValues];
        for (NSDictionary *phoneEntry in phoneEntries) {
            NSNumber *storedPhoneId = [phoneEntry objectForKey:PersonPhoneId];
            found = [phoneId isEqualToNumber:storedPhoneId];
            if (found) {
                foundPhoneEntry = phoneEntry;
                break;
            }
        }
        
        if (found) {
            break;
        }
    }

    return foundPhoneEntry;
}
                            
- (NSDictionary *)findPhoneEntryFromPerson:(NSDictionary *)person forPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    NSDictionary *foundPhoneEntry = nil;
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSArray *phoneEntries = [phoneList allValues];
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
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
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSArray *phoneEntries = [phoneList allValues];
    
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
        NSNumber *potentialMatch = [phoneEntry objectForKey:PersonPhoneId];
        found = [potentialMatch isEqualToNumber:phoneId];
        
        if (found) {
            [phoneEntry setObject:[NSNumber numberWithBool:status] forKey:PersonIsFavorite];
            
            if (status == true) {
                // this is for unfavoriting, as we only have the phoneId when unfavoriting
                [phoneEntry setObject:person forKey:FavoritePersonRefName];
            } else {
                // this is for unfavoriting, as we only have the phoneId when unfavoriting
                [phoneEntry setObject:nil forKey:FavoritePersonRefName];
            }
            
            break;
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

@end










// 