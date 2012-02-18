//
//  AddressBookContainer.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressBookContainer.h"
#import "CallButtonDelegate.h"
#import "FavoritesListDelegate.h"

@interface ContactListContainer : AddressBookContainer <UITableViewDataSource, FavoritesListDelegate>
{
    NSMutableArray *_contactList;
    NSMutableArray *_favoriteList;
    
    BOOL _favoritesModified;
}

@property (strong, nonatomic) NSMutableArray *contactList;
@property (nonatomic) BOOL favoritesModified;

- (void)collectAddressBookInfo;

- (NSDictionary *)getPersonForPath:(NSIndexPath *)indexPath;

@end
