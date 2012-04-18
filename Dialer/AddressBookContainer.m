//
//  AddressBookContainer.m
//  Dialer
//
//  Created by William Richardson on 4/15/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "AddressBookContainer.h"

@implementation AddressBookContainer

- (ABAddressBookRef) AddressBookCreate
{
    return  ABAddressBookCreate();
}

- (CFArrayRef) AddressBookCopyArrayOfAllPeople:(ABAddressBookRef)addressBook
{
    return ABAddressBookCopyArrayOfAllPeople(addressBook);
}

- (CFIndex) AddressBookGetPersonCount:(ABAddressBookRef)addressBook
{
    return ABAddressBookGetPersonCount(addressBook);
}

- (ABMultiValueRef) RecordCopyValue:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId
{
    return (NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty);
}

- (CFIndex) MultiValueGetCount:(ABMultiValueRef)phones
{
    return ABMultiValueGetCount(phones);
}

- (CFStringRef) MultiValueCopyLabelAtIndex:(ABMultiValueRef)phones index:(CFIndex)index
{
    return ABMultiValueCopyLabelAtIndex(phones, index);
}

@end
