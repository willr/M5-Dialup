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

- (void) addressBookCreate;

- (NSArray *) copyAddressBookArrayOfAllPeople;

- (NSArray *) copyAddressBookArrayOfAllSources;

- (NSArray *) copyAddressBookArrayOfAllPeopleInSource:(ABRecordRef)source;

- (ABRecordID) recordGetRecordID:(ABRecordRef)source;

- (CFIndex) addressBookGetPersonCount;

- (NSString *) copyRecordValueAsString:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId;

- (NSNumber *) copyRecordValueAsNumber:(ABRecordRef)ref propertyId:(ABPropertyID)propertyId;

- (CFIndex) multiValueGetCount:(ABMultiValueRef)phones;

- (NSString *) copyMultiValueLabelAtIndex:(ABMultiValueRef)phones index:(CFIndex)index;

- (NSString *) copyMultiValueValueAtIndex:(ABMultiValueRef)phones index:(CFIndex)index;

@end
