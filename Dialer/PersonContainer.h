//
//  IndividualContainer.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressBookContainer.h"
#import "FavoritesListDelegate.h"
#import "ToggleDelegate.h"

@interface PersonContainer : AddressBookContainer <UITableViewDataSource, ToggleDelegate>
{
    NSDictionary *_person;
    id<FavoritesListDelegate> _favoritesListDelegate;
}

@property (strong, nonatomic) NSDictionary *person;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic) id<FavoritesListDelegate> favoritesListDelegate;

- (NSDictionary *)getNameAndPhoneNumFor:(NSIndexPath *)indexPath;

@end
