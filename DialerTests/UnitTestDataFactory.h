//
//  UnitTestDataFactory.h
//  Dialer
//
//  Created by William Richardson on 4/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitTestDataFactory : NSObject

+ (NSDictionary *) loadContactEntries;

+ (NSDictionary *) createContactEntries;

+ (NSDictionary *)createContactEntriesWithStartingPhoneId:(int)phoneId;

+ (NSDictionary *) createUserA;

+ (NSDictionary *) createUserB;

+ (NSUInteger) standAloneUserPhoneId;

+ (NSNumber*) getFirstFoundPhoneId: (NSDictionary *) person;

+ (NSMutableDictionary *) createMutableCopyFromReadonly:(NSDictionary *)person;

@end
