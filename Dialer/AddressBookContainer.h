//
//  AddressBookContainer.h
//  
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CallButtonDelegate.h"

@interface AddressBookContainer : NSObject {
    id _delegate;
}

@property (strong, nonatomic) id<CallButtonDelegate> delegate;

- (NSString *) getPhoneLabelForDisplay: (NSString *) label;

- (UIButton *) configureCallButton;

- (UIButton *) createFavoriteButton;

- (NSDictionary *) createNewFavoriteFromContact: (NSDictionary *) person  
                                contactIndex: (int) contactIndex 
                                  phoneIndex: (int) phoneIndex ;

- (NSNumber*) getFirstFoundPhoneId: (NSDictionary*) person ;

- (BOOL) modifyFavoriteStatusOnPerson: (NSDictionary*) person 
                               status: (BOOL) status ;

- (void) modifyFavoriteStatus: (NSArray*) list 
                      phoneId: (NSNumber*) phoneId 
                       status: (BOOL) status ;

- (void)addDistinctUserToList:(NSMutableArray *)list 
                       lookup:(NSMutableDictionary *)hashedList 
                       person:(NSDictionary *)person;

@end
