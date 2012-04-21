//
//  ContactListContainer+PrivateMethods.h
//  Dialer
//
//  Created by William Richardson on 4/18/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactListContainer (PrivateMethods)

- (void)getCopyFrom:(ABMultiValueRef)phones 
            withKey:(const CFStringRef)key 
            atIndex:(CFIndex)index 
          placeInto:(NSMutableDictionary *)dict 
      havingPhoneId:(int)phoneId;

- (BOOL)addUserName:(ABRecordRef)ref dOfPerson:(NSMutableDictionary *)dOfPerson;

- (void)addContactPhones:(ABRecordRef)ref 
               dOfPerson:(NSMutableDictionary *)dOfPerson 
                 phoneId:(int *)phoneId
             contactList:(NSMutableArray *)contactList
           contactLookup:(NSMutableDictionary *)contactLookup;

@end
