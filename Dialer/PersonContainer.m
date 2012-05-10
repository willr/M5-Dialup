//
//  IndividualContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "PersonContainer.h"
#import "PersonContainer+PrivateMethods.h"
#import "ToggleImageControl.h"
#import "Constants.h"

@interface PersonContainer ()


@end

@implementation PersonContainer

@synthesize person = _person;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization

        // Person dictionary will be set on cellSelected from teh ContactViewController
    }
    return self;
}

- (void) dealloc
{
    self.person = nil;
    
    [super dealloc];
}

// person name
- (NSString *)name
{
    return [self.person objectForKey:PersonName];
}

// build the name and phone entry dictionary for callling out and display in table cell, based on the position in the contact list
- (NSDictionary *)nameAndPhoneNumberAtIndex:(NSUInteger)index
{
    NSMutableDictionary *phoneEntry = [self phoneEntryAtIndex:index];
    
    NSString *phoneNumberDigits = [phoneEntry objectForKey:PersonPhoneNumberDigits];
    if (phoneNumberDigits == nil) {
        phoneNumberDigits = [self getPhoneNumberDigitsRegex:[phoneEntry objectForKey:PersonPhoneNumber]];
        [phoneEntry setValue:phoneNumberDigits forKey:PersonPhoneNumberDigits];
    }
    
    return [self namePhoneNumberAndType:phoneEntry 
                                   name:[self name] 
                              phoneType:[self phoneTypeAtIndex:index] 
                            phoneDigits:phoneNumberDigits];
}

// phone entry for phone number in that section number
- (NSMutableDictionary *)phoneEntryAtIndex:(NSUInteger)entryPos
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    NSMutableDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:entryPos];
    // NSLog(@"phoneEntryAtIndex: %@", phoneList);
    
    return phoneEntry;
}

// total number of phone numbers a person has
- (NSUInteger) count
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    
    return [phoneList count];
}

// phone type at phone number position
- (NSString *) phoneTypeAtIndex:(NSUInteger)index
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    
    return [self getPhoneLabelForDisplay:[[phoneList allKeys] objectAtIndex:index]];
}

// phoneId at phone number position
- (NSNumber *) phoneIdAtIndex:(NSUInteger)index
{
    NSDictionary *phoneEntry = [self phoneEntryAtIndex:index];

    return [phoneEntry objectForKey:PersonPhoneId];
}


@end
