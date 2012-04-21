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

@property (nonatomic) ABAddressBookRef addressBookRef;

@end

@implementation AddressBookContainer

@synthesize addressBookRef = _addressBookRef;

- (id) init
{
    self = [super init];
    if (self != nil) {
        // initialization code here
        
    }
    
    return self;
}

- (void) addressBookCreate
{
    self.addressBookRef = ABAddressBookCreate();
    
    return;
}

- (NSString *) recordCopyValue:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId
{
    return ABRecordCopyValue(ref, propertyId);
}

- (NSArray *) addressBookCopyArrayOfAllPeople
{
    return (NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBookRef);
}

- (CFIndex) addressBookGetPersonCount
{
    return ABAddressBookGetPersonCount(self.addressBookRef);
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
