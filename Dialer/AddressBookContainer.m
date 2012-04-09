//
//  AddressBookContainer.m
//  
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressBookContainer.h"
#import "Constants.h"

@implementation AddressBookContainer

@synthesize delegate = _delegate;

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

- (void)checkButtonTapped:(id)sender event:(id)event
{
    [self.delegate checkButtonTapped:sender event:event];
}

- (UIButton *)configureCallButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    callButton.frame = frame;
    
    [callButton setTitle:CallButtonTitle forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

- (UIButton *)createFavoriteButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(165.0, 7.0, 65.0, 30.0);
    callButton.frame = frame;
    
    [callButton setTitle:FavoriteButtonTitle forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
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

- (NSNumber *)getFirstFoundPhoneId:(NSDictionary *)person
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

- (BOOL)modifyFavoriteStatusOnPerson:(NSDictionary *)person status:(BOOL)status
{
    BOOL found = false;
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    NSArray *phoneEntries = [phoneList allValues];
    NSNumber *phoneId;
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
        phoneId = [phoneEntry objectForKey:PersonPhoneId];
        found = [phoneId isEqualToNumber:phoneId];
        [phoneEntry setObject:[NSNumber numberWithBool:status] forKey:PersonIsFavorite];
        if (found) {
            break;
        }
    }
    
    return found;
}

- (void)modifyFavoriteStatus:(NSArray *)list phoneId:(NSNumber *)phoneId status:(BOOL)status
{
    BOOL found = false;
    
    for (NSDictionary *person in list) {
        found = [self modifyFavoriteStatusOnPerson:person status:status];
        
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

- (void)addDistinctPhoneNumbers:(NSDictionary *)person foundPerson:(NSDictionary *)foundPerson
{
    // ok we found a matching name, check all the phoneNumbers for this contact, and add if not exist
    
    BOOL found = false;
    
    NSDictionary *phoneList = [person objectForKey:PersonPhoneList];
    
    for (NSDictionary *phoneEntryKey in phoneList) {
        found = false;
        NSString *newPhoneNum = [[phoneList objectForKey:phoneEntryKey] objectForKey:PersonPhoneNumber];
        // NSLog(@"newPhoneNum: %@", newPhoneNum);
        NSString *newPhoneDigits = [self getPhoneNumberDigitsRegex:newPhoneNum];
        
        NSMutableDictionary *storedPhoneList = [foundPerson objectForKey:PersonPhoneList];
        for (NSMutableDictionary *storedPhoneEntryKey in storedPhoneList) {
            NSMutableDictionary *storedPhoneEntry = [storedPhoneList objectForKey:storedPhoneEntryKey];
            NSString *storedPhoneDigits = [storedPhoneEntry objectForKey:PersonPhoneNumberDigits];
            if (storedPhoneDigits == nil) {
                storedPhoneDigits = [self getPhoneNumberDigitsRegex:[storedPhoneEntry objectForKey:PersonPhoneNumber]];
                [storedPhoneEntry setObject:storedPhoneDigits forKey:PersonPhoneNumberDigits];
            }
            BOOL foundPhoneNum = [storedPhoneDigits isEqualToString:newPhoneDigits];
            if (foundPhoneNum) {
                found = true;
                break;
            }
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
