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

- (NSString *) getPhoneLabelForDisplay: (NSString*) label;

- (UIButton *) createCallButton;

- (UIButton *) createFavoriteButton;

@end
