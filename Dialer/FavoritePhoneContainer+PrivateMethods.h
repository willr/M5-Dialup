//
//  FavoritePhoneContainer+PrivateMethods.h
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritePhoneContainer (PrivateMethods)

- (NSDictionary *) createNewFavoriteFromContact: (NSDictionary *) person  
                                     phoneIndex: (int) phoneIndex ;

- (NSDictionary *)createFavoriteFromContactList:(NSArray *)contactList 
                                   contactIndex:(int)contactIndex 
                                     phoneIndex:(int)phoneIndex;

- (BOOL) modifyFavoriteStatusOnPerson: (NSDictionary*) person 
                              phoneId: (NSNumber *)phoneId 
                               status: (BOOL) status ;

- (void) modifyFavoriteStatus: (NSArray*) list 
                      phoneId: (NSNumber*) phoneId 
                       status: (BOOL) status ;

- (NSInteger) withPerson:(NSDictionary *)person getPhoneIndexForPhoneId:(NSNumber *)phoneId;

- (NSDictionary *) getPhoneEntryFromList:(NSArray *)list forPhoneId:(NSNumber *)phoneId;

- (NSDictionary *)findPhoneEntryFromPerson:(NSDictionary *)person forPhoneId:(NSNumber *)phoneId;

- (BOOL)isFavorite:(NSNumber *) favoriteId withList:(NSArray *)list;

@end
