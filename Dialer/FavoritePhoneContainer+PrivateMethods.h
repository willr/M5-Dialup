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
                                   contactIndex: (int) contactIndex 
                                     phoneIndex: (int) phoneIndex ;

- (NSDictionary *)createFavoriteFromContactList:(NSArray *)contactList 
                                   contactIndex:(int)contactIndex 
                                     phoneIndex:(int)phoneIndex

- (BOOL) modifyFavoriteStatusOnPerson: (NSDictionary*) person 
                              phoneId: (NSNumber *)phoneId 
                               status: (BOOL) status ;

- (void) modifyFavoriteStatus: (NSArray*) list 
                      phoneId: (NSNumber*) phoneId 
                       status: (BOOL) status ;
@end
