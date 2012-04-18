//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 4/15/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "AddressBookContainer.h"

@implementation AddressBookContainer

- (ABAddressBookRef) addressBookCreate
{
    return  ABAddressBookCreate();
}

- (CFArrayRef) addressBookCopyArrayOfAllPeople:(ABAddressBookRef)addressBook
{
    return ABAddressBookCopyArrayOfAllPeople(addressBook);
}

- (CFIndex) addressBookGetPersonCount:(ABAddressBookRef)addressBook
{
    return ABAddressBookGetPersonCount(addressBook);
}

- (ABMultiValueRef) recordCopyValue:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId
{
    return (NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty);
}

- (CFIndex) multiValueGetCount:(ABMultiValueRef)phones
{
    return ABMultiValueGetCount(phones);
}

- (NSString *) multiValueCopyLabelAtIndex:(ABMultiValueRef)phones index:(CFIndex)index
{
    return (NSString *)ABMultiValueCopyLabelAtIndex(phones, index);
}

- (NSString *) multiValueCopyValueAtIndex:(ABMultiValueRef)phones index:(CFIndex)index
{
    return (NSString *)ABMultiValueCopyValueAtIndex(phones, index);
}

@end
