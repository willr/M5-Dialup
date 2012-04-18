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

@property (nonatomic, strong) NSMutableArray *favorites;

@end

@implementation FavoritePhoneContainer

@synthesize favoritesModified = _favoritesModified;
@synthesize favorites = _favorites;

- (NSUInteger)count
{
    return [self.favorites count];
}

- (void)removeFavorite:(NSNumber *)phoneId
{
    // [_favoriteList removeObjectAtIndex:[index intValue]];
    
    [self modifyFavoriteStatus:self.favorites phoneId:phoneId status:NO];
    // [self modifyFavoriteStatus:_contactList phoneId:phoneId status:NO];
    
    self.favoritesModified = true;
}


- (void)addFavorite:(NSNumber *)phoneId
{
    NSDictionary *phoneEntry = [self findPhoneEntryForPhoneId:phoneId];
    
    // TODO: this broken!!!, should do something with distinct, or the same name can be added twice
    [self.favorites addObject:phoneEntry];
    
    // phoneId = [self getFirstFoundPhoneId:personPhone];    
    assert(phoneId != nil);
    
    [self modifyFavoriteStatus:self.favorites phoneId:phoneId status:NO];
    // [self modifyFavoriteStatus:_contactList phoneId:phoneId status:NO];
    
    _favoritesModified = true;
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
                            
- (NSDictionary *)findPhoneEntryForPhoneId:(NSNumber *)phoneId
{
    return nil;
}


- (NSDictionary *)createNewFavoriteFromContact:(NSDictionary *)person 
                                  contactIndex:(int)contactIndex 
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
                                 contactIndex:contactIndex 
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
    BOOL found = false;
    BOOL isFavorite = false;
    NSNumber *yesFavorite = [NSNumber numberWithBool:YES];
    
    for (NSDictionary *person in list) {
        NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
        NSArray *phoneEntries = [phoneList allValues];
        for (NSDictionary *phoneEntry in phoneEntries) {
            NSNumber *storedPhoneId = [phoneEntry objectForKey:PersonPhoneId];
            found = [phoneId isEqualToNumber:storedPhoneId];
            if (found) {
                NSNumber *isFavoriteStored = [phoneEntry objectForKey:PersonIsFavorite];
                isFavorite = [isFavoriteStored isEqualToNumber:yesFavorite];;
                break;
            }
        }
        
        if (found) {
            break;
        }
    }
    
    return isFavorite;
}

@end
