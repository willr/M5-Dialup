//
//  AddressBookContainer.m
//  
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactBaseContainer.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "TestFlight.h"

@implementation ContactBaseContainer

// convert the funky unique labels in the phoneEntry key into displayable strings
- (NSString *)getPhoneLabelForDisplay:(NSString *)label
{
    NSRange foundRange = [label rangeOfString:WorkPhoneLabelSubStringCheck
                                      options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return WorkPhoneLabel;
    }
    
    foundRange = [label rangeOfString:MobilePhoneLabelSubStringCheck
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return MobilePhoneLabel;
    }
    
    foundRange = [label rangeOfString:IPhonePhoneLabelSubStringCheck
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return IPhonePhoneLabel;
    }
    
    foundRange = [label rangeOfString:HomePhoneLabelSubStringCheck
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return HomePhoneLabel;
    }
    
    return nil;
}

// get only the phone digit (numbers) and store them, so I can compare for uniqueness
- (NSString *)getPhoneNumberDigitsRegex:(NSString *)phoneNumber
{
    // Setup an NSError object to catch any failures
	NSError *error = NULL;
    
    // create the NSRegularExpression object and initialize it with a pattern
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PhoneNumberDigitsPattern 
                                                                           options:NSRegularExpressionCaseInsensitive 
                                                                             error:&error];
    
    if (regex == nil && error) {
        RTFLog(@"getPhoneNumberDigitsRegex ERROR:: Pattern: %@, Error Desc: %@, Error Code: %d, Error Domain: %@", 
               PhoneNumberDigitsPattern, 
               error.localizedDescription, 
               error.code, 
               error.domain);
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate) displayErrorMessage:@"Error parsing Contact info" 
                                                                          additionalInfo:nil 
                                                                               withError:error];
    }
    
    // get the result of the regEx
    NSArray *results = [regex matchesInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];

    NSString *digits = @"";
    if (results != nil) {
        // iterate through the results, we pull each contiguous substring range out one at a time
        for (NSTextCheckingResult *result in results) {
            NSRange range = [result rangeAtIndex:0];
            /*
            NSLog(@"%d,%d group #%d %@", range.location, range.length, 0,
                (range.length == 0 ? @"--" : [phoneNumber substringWithRange:range]));
             */
            if (range.length == 0) {
                continue;
            }

            // with the given range, append to the string we are building
            digits = [digits stringByAppendingString:[phoneNumber substringWithRange:range]];
        }
    }

    // NSLog(@"digits: %@", digits);
    return digits;
}

// match the phone number digits, against a stored phoneEntry, if digits are equal, then return true
- (BOOL)isPhoneEntryMatch:(NSMutableDictionary *)storedPhoneEntry
                  newPhoneDigits:(NSString *)newPhoneDigits
{
    /*
    // if list is empty
    if (storedPhoneList == nil || [storedPhoneList count] == 0) {
        return false;
    }
    
    
    // retrieve the stored phone entry we are going to compare, by the passed in key
    NSMutableDictionary *storedPhoneEntry = [storedPhoneList objectForKey:storedPhoneEntryKey];
    if (storedPhoneEntry == nil || [storedPhoneEntry count] == 0) {
        return false;
    }
    */
    
    // get the phone number digits for the retrieved phoneEnty
    NSString *storedPhoneDigits = [storedPhoneEntry objectForKey:PersonPhoneNumberDigits];
    if (storedPhoneDigits == nil) {
        storedPhoneDigits = [self getPhoneNumberDigitsRegex:[storedPhoneEntry objectForKey:PersonPhoneNumber]];
        [storedPhoneEntry setObject:storedPhoneDigits forKey:PersonPhoneNumberDigits];
    }
    
    // compare the stored phone entry digits with the new digits, see if they are the same
    BOOL found = [storedPhoneDigits isEqualToString:newPhoneDigits];

    return found;
}

// for a given (stored) user, see if the phone entries for that user match a new user.
//  Add the new phone entries for the new user, to the stored users list
- (void)addDistinctPhoneNumbers:(NSDictionary *)person storedPerson:(NSDictionary *)storedPerson
{
    // for each phone entry in a person's phone list, compare the phone digits, and add the missing ones to the stored (found) set
    BOOL found = false;
    
    // get the phone for the new person we want to add to the stored list
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    for (NSString *phoneEntryKey in phoneList) {
        found = false;
        // get the new persons phone entry, interating over all the keys in the dictionary
        NSString *newPhoneNum = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneNumber];
        // get the new persons phone number digits for comparison
        NSString *newPhoneDigits = [self getPhoneNumberDigitsRegex:newPhoneNum];
        
        // get the stored (existing) persons phone list
        NSMutableDictionary *storedPhoneList = [storedPerson objectForKey:PersonPhoneList];
        for (NSString *storedPhoneEntryKey in storedPhoneList) {
            // for each stored person phone entries, found by interation over the keys in the dictionary
            //  check if the new persons digits match the stored (existing) persons digits
            NSMutableDictionary *storedPhoneEntry = [storedPhoneList objectForKey:storedPhoneEntryKey];
            found = [self isPhoneEntryMatch:storedPhoneEntry 
                             newPhoneDigits:newPhoneDigits];
            
            // to be considered distinct the phoneLable (phoneType) has to match as well
            if (found) {
                NSString *newPhoneType = [self getPhoneLabelForDisplay:phoneEntryKey];
                NSString *storedPhoneType = [self getPhoneLabelForDisplay:storedPhoneEntryKey];
                if ([newPhoneType isEqualToString:storedPhoneType]) {
                    break;
                } else {
                    found = NO;
                }
            }
        }
        
        // after searching all the stored (existing) persons phone entries, if not found then add
        if (!found) {
            // check to see if we see a value at the one we are about to overwrite
            NSDictionary *savedPhoneEntry = [storedPhoneList objectForKey:phoneEntryKey];
            if (savedPhoneEntry != nil) {
                // if yes then make them distinct by adding the phoneId
                NSString *moddedKey = [NSString stringWithFormat:@"%@+%@", phoneEntryKey, 
                                       [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneId]];
                [storedPhoneList setObject:[phoneList objectForKey:phoneEntryKey] forKey:moddedKey];
            } else {
                // if no then save
                [storedPhoneList setObject:[phoneList objectForKey:phoneEntryKey] forKey:phoneEntryKey];
            }
        }
    }
}

// add a given (new) user to the list of users, with each user being distinctive, and all entries for that user combined into one
//  person contact entry
- (void)addDistinctUserToList:(NSMutableArray *)list lookup:(NSMutableDictionary *)hashedList person:(NSDictionary *)person
{
    // get the stored (existing) person from the list, by name
    // we dont do anything special to find different permutations of the names.
    NSString *name = [person objectForKey:PersonName];
    NSDictionary *foundPerson = [hashedList objectForKey:name];
    
    // if not found, then add to list, and the hashedList (NSDictionary)
    if (nil == foundPerson) {
        [list addObject:person];
        [hashedList setObject:person forKey:name];
        // NSLog(@"Distinct Person: %@", person);
        // TODO: filter out multiple copies here too... 
        
    } else {
        // NSLog(@"foundPerson %@", person);
        // ok we found a matching name, check all the phoneNumbers for this contact, and add if not exist
        [self addDistinctPhoneNumbers:person storedPerson:foundPerson];
    }
}

// create a NSDictionary based on name and phone entry for calling out and display in table cell
- (NSDictionary *)namePhoneNumberAndType:(NSDictionary *)phoneEntry name:(NSString *)name phoneType:(NSString *)phoneType phoneDigits:(NSString *)digits
{
    NSString *phoneNumber = [phoneEntry objectForKey:PersonPhoneNumber];
    
    // create the dictionary
    return [[[NSDictionary alloc] initWithObjectsAndKeys:name, PersonName, 
             phoneNumber, PersonPhoneNumber, 
             phoneType, PersonPhoneLabel,
             digits, PersonPhoneNumberDigits,
             nil] autorelease];
}

// get the phoneEntry from that a person that has the phoneId
- (NSMutableDictionary *)findPhoneEntryFromPerson:(NSDictionary *)person forPhoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    NSMutableDictionary *foundPhoneEntry = nil;
    // get the phoneList
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];

    for (NSString *phoneEntryKey in phoneList) {
        // get phone entry, iterating by key across all phoneEntries
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

@end









