//
//  AddressBookContainer.h
//  Dialer
//
//  Created by William Richardson on 4/15/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface AddressBookContainer : NSObject

- (ABAddressBookRef) AddressBookCreate;

- (CFArrayRef) AddressBookCopyArrayOfAllPeople:(ABAddressBookRef)addressBook;

- (CFIndex) AddressBookGetPersonCount:(ABAddressBookRef)addressBook;

- (ABMultiValueRef) RecordCopyValue:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId;

- (CFIndex) MultiValueGetCount:(ABMultiValueRef)phones;

- (CFStringRef) MultiValueCopyLabelAtIndex:(ABMultiValueRef)phones index:(CFIndex)index;

@end
