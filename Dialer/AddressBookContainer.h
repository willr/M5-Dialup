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

- (ABAddressBookRef) addressBookCreate;

- (CFArrayRef) addressBookCopyArrayOfAllPeople:(ABAddressBookRef)addressBook;

- (CFIndex) addressBookGetPersonCount:(ABAddressBookRef)addressBook;

- (ABMultiValueRef) recordCopyValue:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId;

- (CFIndex) multiValueGetCount:(ABMultiValueRef)phones;

- (NSString *) multiValueCopyLabelAtIndex:(ABMultiValueRef)phones index:(CFIndex)index;

- (NSString *) multiValueCopyValueAtIndex:(ABMultiValueRef)phones index:(CFIndex)index;

@end
