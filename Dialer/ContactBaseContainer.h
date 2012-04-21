//
//  AddressBookContainer.h
//  
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CallButtonDelegate.h"

@interface ContactBaseContainer : NSObject 

- (NSString *) getPhoneLabelForDisplay: (NSString *) label;

- (void)addDistinctUserToList:(NSMutableArray *)list 
                       lookup:(NSMutableDictionary *)hashedList 
                       person:(NSDictionary *)person;

- (NSString *)getPhoneNumberDigitsRegex:(NSString *)phoneNumber;

@end
