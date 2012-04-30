//
//  ContactsDataSource.h
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContactsBaseDataSource.h"
#import "ContactListContainer.h"
#import "FavoritePhoneContainer.h"

@interface ContactsDataSource : ContactsBaseDataSource <UITableViewDataSource>
{
    ContactListContainer        *_contacts;
    FavoritePhoneContainer      *_favorites;
}

@property (retain, nonatomic) ContactListContainer      *contacts;
@property (retain, nonatomic) FavoritePhoneContainer    *favorites;

- (void)collectAddressBookInfo;

- (NSDictionary *)personAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL) favoritesModified;

- (NSDictionary *)nameAndPhoneNumberAtIndexPath:(NSIndexPath *)indexPath;

@end
