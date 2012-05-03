//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 4/15/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "AddressBookContainer.h"

@interface AddressBookContainer ()
{
    ABAddressBookRef _addressBookRef;
}

@end

@implementation AddressBookContainer

- (id) init
{
    self = [super init];
    if (self != nil) {
        // initialization code here
        
    }
    
    return self;
}

- (void) dealloc
{
    if (_addressBookRef != nil) {
        CFRelease(_addressBookRef);
        _addressBookRef = nil;
    }
    [super dealloc];
}

- (void) addressBookCreate
{
    _addressBookRef = ABAddressBookCreate();
    
    return;
}

- (NSString *) copyRecordValueAsString:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId
{
    return ABRecordCopyValue(ref, propertyId);
}

- (NSNumber *) copyRecordValueAsNumber:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId
{
    return ABRecordCopyValue(ref, propertyId);
}

- (NSArray *) copyAddressBookArrayOfAllPeople
{
    return (NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
}

- (NSArray *) copyAddressBookArrayOfAllSources
{
    return (NSArray *)ABAddressBookCopyArrayOfAllSources(_addressBookRef);
}

- (NSArray *) copyAddressBookArrayOfAllPeopleInSource:(ABRecordRef)source
{
    return (NSArray *)ABAddressBookCopyArrayOfAllPeopleInSource(_addressBookRef, source);
}

- (CFIndex) addressBookGetPersonCount
{
    return ABAddressBookGetPersonCount(_addressBookRef);
}

- (CFIndex) multiValueGetCount:(ABMultiValueRef)phones
{
    return ABMultiValueGetCount(phones);
}

- (NSString *) copyMultiValueLabelAtIndex:(ABMultiValueRef)phones index:(CFIndex)index
{
    return (NSString *)ABMultiValueCopyLabelAtIndex(phones, index);
}

- (NSString *) copyMultiValueValueAtIndex:(ABMultiValueRef)phones index:(CFIndex)index
{
    return (NSString *)ABMultiValueCopyValueAtIndex(phones, index);
}

@end
