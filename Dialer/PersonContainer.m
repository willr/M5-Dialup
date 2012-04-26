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

    }
    return self;
}

- (NSString *)name
{
    return [self.person objectForKey:PersonName];
}

- (NSDictionary *)nameAndPhoneNumberAtIndex:(NSUInteger)index
{
    NSMutableDictionary *phoneEntry = [self phoneEntryAtIndex:index];
    NSString *phoneTxt = [phoneEntry objectForKey:PersonPhoneNumber];
    
    NSDictionary *copy = [[[NSDictionary alloc] initWithObjectsAndKeys:
                           [self name], PersonName, 
                           phoneTxt, PersonPhoneNumber, 
                           nil] autorelease];
    
    return copy;
}

- (NSMutableDictionary *)phoneEntryAtIndex:(NSUInteger)entryPos
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    NSMutableDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:entryPos];
    
    return phoneEntry;
}

- (NSUInteger) count
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    
    return [phoneList count];
}

- (NSString *) phoneTypeAtIndex:(NSUInteger)index
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    
    return [self getPhoneLabelForDisplay:[[phoneList allKeys] objectAtIndex:index]];
}

- (NSNumber *) phoneIdAtIndex:(NSUInteger)index
{
    NSDictionary *phoneEntry = [self phoneEntryAtIndex:index];

    return [phoneEntry objectForKey:PersonPhoneId];
}


@end
