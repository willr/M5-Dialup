//
//  FavoritePhoneContainer.m
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "FavoritePhoneContainer.h"
#import "Constants.h"
#import "AppDelegate.h"

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
        
        // list of saved favorites
        self.favorites = [[[NSMutableArray alloc] init] autorelease];
        // this should be a list of contacts, referenced from the contact list, that are favorites.
        //      this encapsulates the favoritesContainer unfavoriting a person from the contact list, when they are removed from the favoritesList
        self.contactRef = [[[NSMutableDictionary alloc] init] autorelease];
        
    }
    return self;
}

- (void) dealloc
{
    self.favorites = nil;
    self.contactRef = nil;
    
    [super dealloc];
}

// total number of favorites
- (NSUInteger)count
{
    return [self.favorites count];
}

// remove a favorite from list, "un-favorite" them.  will also remove the favorite flag from the contactList
- (void)removeFavorite:(NSNumber *)phoneId
{
    // get the contact from the contactsRef (meaning the contactList) as we store a reference here
    //      and set the status to no
    [self modifyFavoriteStatusOnPerson:[self.contactRef objectForKey:phoneId] phoneId:phoneId status:NO];
    // set the status to no, on the favorited contact
    [self modifyFavoriteStatus:self.favorites phoneId:phoneId status:NO];
    // remove the favorite from the list
    [self.favorites removeObject:[self personFromList:self.favorites phoneId:phoneId]];
    
    self.favoritesModified = true;
}

// add a favorite to the favoritesList. Will store a reference to the person passed in so as to be able to "un-favorite" then if needed
- (void)addFavorite:(NSDictionary *)person phoneId:(NSNumber *)phoneId
{
    [self internalAddFavorite:person phoneId:phoneId favorites:self.favorites];
}

// internal to be accessed only my other methods in class, for reloading, or whatever
// add a favorite to the favoritesList. Will store a reference to the person passed in so as to be able to "un-favorite" then if needed
- (void)internalAddFavorite:(NSDictionary *)person phoneId:(NSNumber *)phoneId favorites:(NSMutableArray *)favorites
{
    if ([self isFavorite:phoneId withList:favorites]) {
        return;
    }
    
    // NSLog(@"addFavorite: %@", person);
    
    // get teh position of the phoneEntry we are favoriting
    NSInteger foundPhoneIndex = [self withPerson:person getPhoneIndexForPhoneId:phoneId];
    // create a custom dictionary (person w/ phoneEntry) for the favorite
    NSDictionary *favorite = [self createNewFavoriteFromContact:person phoneIndex:foundPhoneIndex];
    
    // add created entry to favorites list
    // [self.favorites addObject:favorite];
    [favorites addObject:favorite];
    
    // modify passed in person and favorite, favorite status as yes
    [self modifyFavoriteStatusOnPerson:person phoneId:phoneId status:YES];
    [self modifyFavoriteStatusOnPerson:favorite phoneId:phoneId status:YES];
    
    // NSLog(@"favorite: %@", favorite);
    
    _favoritesModified = true;
}
                              
// get the phoneEntry index in the phoneList, that matches the phoneId passed in
- (NSInteger) withPerson:(NSDictionary *)person getPhoneIndexForPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    BOOL foundPhoneId = false;
    // get phonelist
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];

    NSInteger i = 0;
    for (NSString *phoneEntryKey in phoneList) {
        // get phoneId for this entry, iterating by key across all phoneEntries
        NSNumber *phoneIdToCheck = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId];
        found = [phoneId isEqualToNumber:phoneIdToCheck];
        
        // if match return position
        if (found) {
            foundPhoneId = true;
            break;
        }
        i++;
    }
    
    return foundPhoneId ? i : -1;
}

// is pased in phoneId a favorite
- (BOOL)isFavorite:(NSNumber *) favoriteId
{
    BOOL found = [self isFavorite:favoriteId withList:self.favorites];
    
    return found;
}

// is pased in phoneId a favorite on passed in list
- (BOOL)isFavorite:(NSNumber *) favoriteId withList:(NSArray *)list
{
    BOOL found = false;
    
    for (NSDictionary *person in list) {
        // get phone list
        NSDictionary *phoneList = [person objectForKey:PersonPhoneList];

        NSNumber *phoneId;
        for (NSString *phoneEntryKey in phoneList) {
            // get phoneId for this entry, iterating by key across all phoneEntries
            phoneId = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId];
            found = [phoneId isEqualToNumber:favoriteId];
            if (found) {
                break;
            }
        }
        
        // if match return true
        if (found) {
            break;
        }
    }
    
    return found;
}

// return favorite dictionary of person at index in favorites list
- (NSDictionary *)personAtIndex:(NSInteger)pos
{
    return [self.favorites objectAtIndex:pos];
}

// return phoneId of phoneEntry at index in favorites list
- (NSNumber *) phoneIdAtIndex:(NSInteger)pos
{
    NSDictionary *person = [self personAtIndex:pos];
    
    // we can return the first found phoneId cause for Favorites, 
    //  we will only ever have on phoneEntry in the phoneList
    return [self getFirstFoundPhoneId:person];
}

// build the name and phone entry dictionary for callling out and display in table cell, based on the position in the contact list
- (NSDictionary *) nameAndPhoneNumberAtIndex:(NSUInteger)pos;
{
    NSDictionary *person = [self personAtIndex:pos];
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSString *phoneType = [[phoneList allKeys] objectAtIndex:0];
    NSDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:0];
    
    return [self namePhoneNumberAndType:phoneEntry name:[person objectForKey:PersonName] phoneType:[self getPhoneLabelForDisplay:phoneType]];
    
}

// get the first phoneId from all phoneEntry on a person that has a phoneId.  this should really be first phoneEntries phoneId
- (NSNumber *)getFirstFoundPhoneId:(NSDictionary *)person
{
    NSNumber *phoneId = nil;
    BOOL found = false;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    for (NSString *phoneEntryKey in phoneList) {
        // get phoneId for this entry, iterating by key across all phoneEntries
        phoneId = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId];
        found = phoneId != nil;
        
        if (found) {
            break;
        }
    }
    
    return phoneId;
}

// get person dictionary from favorites list that has a phoneEntry that matches the phoneId
- (NSDictionary *)personFromList:(NSArray *)list phoneId:(NSNumber *)phoneId
{
    NSDictionary *foundPerson = nil;
    NSDictionary *foundPhoneEntry = nil;
    
    for (NSDictionary *person in list) {
        // get phoneId for this entry, iterating by key across all phoneEntries
        foundPhoneEntry = [self findPhoneEntryFromPerson:person forPhoneId:phoneId];
        if (foundPhoneEntry != nil) {
            foundPerson = person;
        }
    }
    
    return foundPerson;
}

// get phone entry from favorites list that has a phoneEntry that matches the phoneId
- (NSMutableDictionary *) getPhoneEntryFromList:(NSArray *)list forPhoneId:(NSNumber *)phoneId
{
    NSMutableDictionary *foundPhoneEntry = nil;
    
    for (NSDictionary *person in list) {
        // get phoneEntry for this entry, iterating by key across all phoneEntries
        foundPhoneEntry = [self findPhoneEntryFromPerson:person forPhoneId:phoneId];
        if (foundPhoneEntry != nil) {
            break;
        }
    }

    return foundPhoneEntry;
}
                            

// create a new favorite (dictionary) from contact using phoneId as for the phone entry
- (NSDictionary *)createNewFavoriteFromContact:(NSDictionary *)person 
                                    phoneIndex:(int)phoneIndex
{
    NSMutableDictionary *fav = [[[NSMutableDictionary alloc] init] autorelease];
    NSString * favName = [person objectForKey:PersonName];
    NSMutableDictionary *favPhoneList = [[NSMutableDictionary alloc] init];
    
    // set attribs on favorite dictionary
    [fav setObject:favName forKey:PersonName];
    [fav setObject:favPhoneList forKey:PersonPhoneList];
    
    // set phoneEntry set by index in the phoneList
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    // NSLog(@"personPhoneList: %@", phoneList);
    [favPhoneList setObject:[[phoneList allValues] objectAtIndex:phoneIndex]                     
                     forKey:[[phoneList allKeys] objectAtIndex:phoneIndex]];
    
    [favPhoneList release];
    
    // NSLog(@"createdFav: %@", fav);
    
    return fav;
}

// create favorite (dictionary) based on index in the phone entry
- (NSDictionary *)createFavoriteFromContactList:(NSArray *)contactList 
                                   contactIndex:(int)contactIndex 
                                     phoneIndex:(int)phoneIndex
{
    NSDictionary *contact = [contactList objectAtIndex:contactIndex];
    
    return [self createNewFavoriteFromContact:contact 
                                   phoneIndex:phoneIndex];
}

// set favorite status on person dictionary
- (BOOL)modifyFavoriteStatusOnPerson:(NSDictionary *)person 
                             phoneId:(NSNumber *)phoneId 
                              status:(BOOL)status
{
    BOOL found = false;
    
    // get the phone entry, based on phoneId from a person dictionary
    NSMutableDictionary *phoneEntry = [self findPhoneEntryFromPerson:person forPhoneId:phoneId];
    if (phoneEntry != nil) {
        // set status on phoneEntry attributes dictionary
        [phoneEntry setObject:[NSNumber numberWithBool:status] forKey:PersonIsFavorite];
        found = true;
        
        // this is for unfavoriting, as we only have the phoneId when unfavoriting
        if (status == true) {
            // add the person to the contactRef dictionary for later lookup
            [self.contactRef  setObject:person forKey:phoneId];
        } else {
            // remove the person from the contactRef dictionary
            [self.contactRef removeObjectForKey:FavoritePersonRefName];
        }
    }
    
    return found;
}

// set favorite status on person dictionary found on list via phoneId
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

// set favorite status on person dictionary found on list via phoneId
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

// get the file path for the favorites file
- (NSString *)favoritesFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FavoritesFileName];
    
    NSLog(@"Favorities File Path: %@", filePath);
    
    // NSAssert(filePath != nil, @"File path should not be nil");
    return filePath;
}

// validate favorite is an actual contact both in name and in digit
- (NSNumber *) returnPhoneIdForValidatedFavorite:(NSDictionary *)favorite asContact:(NSMutableDictionary *)contact
{
    // get the contact's phonelist
    NSMutableDictionary *contactPhoneList = [contact objectForKey:PersonPhoneList];
    // get the potential favorite's phoneList
    NSDictionary *favoritePhoneList = [favorite objectForKey:PersonPhoneList];
    
    NSNumber *matchingPhoneId = nil;
    // get the favorites phoneList enumerator
    NSEnumerator *favoritePhoneListEnumerator = [favoritePhoneList keyEnumerator];
    for (NSString *key in favoritePhoneListEnumerator) {
        // get each phone entry  on a favorite, iterating across the favorite 
        NSDictionary *favoritePhoneEntry = [favoritePhoneList objectForKey:key];
        // get the favorite phone number and digits
        NSString *favoritePhoneNum = [favoritePhoneEntry objectForKey:PersonPhoneNumber];
        NSString *favoritePhoneDigits = [self getPhoneNumberDigitsRegex:favoritePhoneNum];
        
        // check to see if we find the phone digits in the contact phone entry list
        for (NSString *contactPhoneEntryKey in contactPhoneList) {
            // for each stored person phone entries, found by interation over the keys in the dictionary
            //  check if the new persons digits match the stored (existing) persons digits
            NSMutableDictionary *contactPhoneEntry = [contactPhoneList objectForKey:contactPhoneEntryKey];
            BOOL found = [self isPhoneEntryMatch:contactPhoneEntry 
                                  newPhoneDigits:favoritePhoneDigits];
        
            // if found return
            if (found) {
                NSDictionary *phoneEntry = [contactPhoneList objectForKey:key];
                matchingPhoneId = [phoneEntry objectForKey:PersonPhoneId];
                break;
            }
        }
    }
    
    return matchingPhoneId;
}

// load the save favorites from the file
- (void) loadSavedFavorites:(NSDictionary *)contactLookup
{
    // dispatch this to a background thread, to handle the heavy load of processing the contacts
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // NSLog(@"loadSavedFavorites::On async thread");
        
        // here actually load the favorites, potientially expensive
        NSMutableArray *newFavorites = [[NSMutableArray alloc] init];
        [self internalLoadSavedFavorites:contactLookup favorites:newFavorites];
        
        NSLog(@"newFavorites: %d", [newFavorites count]);
        
        // dispatch back to the mainUI thread to handle the replacing of the containers
        dispatch_async(dispatch_get_main_queue(), ^{
        
            // NSLog(@"loadSavedFavorites::On main thread");
            
            // set the new favorites Array
            self.favorites = newFavorites;
            _favoritesModified = true;
            
            // hmm how to get the tableView to redraw, must have a sticky bit..
            // ok push the notification via NSNotificationCenter.. 
            [[NSNotificationCenter defaultCenter] postNotificationName:FavoritesReloaded
                                                                object:self
                                                              userInfo:nil];
        });
    });
}

// load the save favorites from the file
- (void) internalLoadSavedFavorites:(NSDictionary *)contactLookup favorites:(NSMutableArray *)favorites
{
    // get the favorite file path
    NSString *filePath = [self favoritesFilePath];

    // load a NSData with contents of the favorites file
    NSData *favoritesData = [NSData dataWithContentsOfFile:filePath];
    // if cant load it, or file is empty the bail
    if (favoritesData == nil) {
        // just exit since there is no file to load
        return;
    }
    
    // when deserialized create as a mutable data structure
    NSPropertyListFormat *format = NULL;
    NSError *error = nil;
    NSArray *serializedContactList = [NSPropertyListSerialization propertyListWithData:favoritesData 
                                                                               options:NSPropertyListMutableContainersAndLeaves 
                                                                                format:format 
                                                                                 error:&error];
    
    if (serializedContactList == nil && error) {
        NSLog(@"Error Descr %@",error.localizedDescription);
        NSLog(@"Error Code %@",error.code);    
        NSLog(@"Error Domain %@",error.domain);
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate) displayErrorMessage:@"Error Reading Saved Contacts" 
                                                                          additionalInfo:@"Try Again" 
                                                                               withError:error];
                                                                             
        return;
    }
    
    // validate each serialize favorite actually exists in the list of contacts
    for (NSMutableDictionary *favoritePerson in serializedContactList) {
        NSString *serializedPersonName = [favoritePerson objectForKey:PersonName];
        NSMutableDictionary *contactPerson = [contactLookup objectForKey:serializedPersonName];
        
        // check the name is the same, then check the digits are the same
        if([[favoritePerson objectForKey:PersonName] isEqual:serializedPersonName]) {
            NSNumber *contactPhoneId = [self returnPhoneIdForValidatedFavorite:favoritePerson asContact:contactPerson];
            if (contactPhoneId != nil) {
                // now we know they are the same, both name and phone number digits now match
                // [self.favorites addObject:favoritePerson];
                [self internalAddFavorite:contactPerson phoneId:contactPhoneId favorites:favorites];
            }
        }
    }
}

// save a serialized representation of the favorites into the favorites file
- (void) saveFavorites
{
    // dispatch this to a background thread, to handle the heavy load of processing the contacts
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // here is where we save the favorites file
        [self internalSaveFavorites];
        
    });
}

// save a serialized representation of the favorites into the favorites file
- (void) internalSaveFavorites
{
    NSString *filePath = [self favoritesFilePath];
    
    // NSLog(@"saveFavorites current Favorites: %@", self.favorites);
    
    // save a serialized representation of the favorites into the favorites file as an xml file
    NSError *error = nil;
    NSData *favoritesData = [NSPropertyListSerialization dataWithPropertyList:self.favorites 
                                                                       format:NSPropertyListXMLFormat_v1_0 
                                                                      options:0 
                                                                        error:&error];
    if (favoritesData == nil && error) {
        NSLog(@"Error Descr %@",error.localizedDescription);
        NSLog(@"Error Code %@",error.code);    
        NSLog(@"Error Domain %@",error.domain);
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate) displayErrorMessage:@"Error Saving Contacts" 
                                                                          additionalInfo:@"Try again" 
                                                                               withError:error];
        return;
    }
    
    NSAssert([favoritesData length] != 0, @"serialization result is empty");
             
    [favoritesData writeToFile:filePath atomically:YES];
}



@end










// 