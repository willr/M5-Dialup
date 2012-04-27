//
//  AddressBookContainer.m
//  
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactBaseContainer.h"
#import "Constants.h"

@implementation ContactBaseContainer

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


- (NSString *)getPhoneNumberDigitsRegex:(NSString *)phoneNumber
{
    // Setup an NSError object to catch any failures
	NSError *error = NULL;
    
    // create the NSRegularExpression object and initialize it with a pattern
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PhoneNumberDigitsPattern 
                                                                           options:NSRegularExpressionCaseInsensitive 
                                                                             error:&error];
    
    NSArray *results = [regex matchesInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];

    NSString *digits = @"";
    if (results != nil) {
        for (NSTextCheckingResult *result in results) {
            NSRange range = [result rangeAtIndex:0];
            /*
            NSLog(@"%d,%d group #%d %@", range.location, range.length, 0,
                (range.length == 0 ? @"--" : [phoneNumber substringWithRange:range]));
             */
            if (range.length == 0) {
                continue;
            }

            digits = [digits stringByAppendingString:[phoneNumber substringWithRange:range]];
        }
    }

    // NSLog(@"digits: %@", digits);
    return digits;
}

- (BOOL)isPhoneEntryMatchWithKey:(NSString *)storedPhoneEntryKey 
          storedPhoneList:(NSMutableDictionary *)storedPhoneList 
           newPhoneDigits:(NSString *)newPhoneDigits
{
    if (storedPhoneList == nil || [storedPhoneList count] == 0) {
        return false;
    }
    
    NSMutableDictionary *storedPhoneEntry = [storedPhoneList objectForKey:storedPhoneEntryKey];
    if (storedPhoneEntry == nil || [storedPhoneEntry count] == 0) {
        return false;
    }
    
    NSString *storedPhoneDigits = [storedPhoneEntry objectForKey:PersonPhoneNumberDigits];
    if (storedPhoneDigits == nil) {
        storedPhoneDigits = [self getPhoneNumberDigitsRegex:[storedPhoneEntry objectForKey:PersonPhoneNumber]];
        [storedPhoneEntry setObject:storedPhoneDigits forKey:PersonPhoneNumberDigits];
    }
    BOOL found = [storedPhoneDigits isEqualToString:newPhoneDigits];

    return found;
}

- (void)addDistinctPhoneNumbers:(NSDictionary *)person foundPerson:(NSDictionary *)foundPerson
{
    // ok we found a matching name, check all the phoneNumbers for this contact, and add if not exist
    
    BOOL found = false;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    
    for (NSString *phoneEntryKey in phoneList) {
        found = false;
        NSString *newPhoneNum = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneNumber];
        NSString *newPhoneDigits = [self getPhoneNumberDigitsRegex:newPhoneNum];
        
        NSMutableDictionary *storedPhoneList = [foundPerson objectForKey:PersonPhoneList];
        for (NSString *storedPhoneEntryKey in storedPhoneList) {
            found = [self isPhoneEntryMatchWithKey:storedPhoneEntryKey 
                                   storedPhoneList:storedPhoneList 
                                    newPhoneDigits:newPhoneDigits];
        }
        
        if (!found) {
            [storedPhoneList setObject:[phoneList objectForKey:phoneEntryKey] forKey:phoneEntryKey];
        }
    }
}

- (void)addDistinctUserToList:(NSMutableArray *)list lookup:(NSMutableDictionary *)hashedList person:(NSDictionary *)person
{
    NSString *name = [person objectForKey:PersonName];
    NSDictionary *foundPerson = [hashedList objectForKey:name];
    
    if (nil == foundPerson) {
        [list addObject:person];
        [hashedList setObject:person forKey:name];
        
        // TODO: filter out multiple copies here too... 
        
    } else {
        [self addDistinctPhoneNumbers:person foundPerson:foundPerson];
        // NSLog(@"foundPerson %@", foundPerson);
    }
}

@end
