//
//  AddressBookContainer.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContactBaseContainer.h"
#import "CallButtonDelegate.h"
#import "AddressBookContainer.h"

@interface ContactListContainer : ContactBaseContainer
{
    NSMutableArray          *_contactList;
    NSMutableDictionary     *_contactLookup;
    
    AddressBookContainer    *_abContainer;
}

@property (retain, nonatomic) NSMutableArray            *contactList;
@property (retain, nonatomic) NSMutableDictionary       *contactLookup;
@property (retain, nonatomic) AddressBookContainer      *abContainer;

- (void)collectAddressBookInfo;

- (NSDictionary *) personForName:(NSString *)name andPhoneId:(NSNumber *)phoneId;

- (NSDictionary *) personAtIndex:(NSUInteger)index;

- (NSDictionary *)nameAndPhoneNumberAtIndex:(NSUInteger)index;

- (NSUInteger)count;

@end
