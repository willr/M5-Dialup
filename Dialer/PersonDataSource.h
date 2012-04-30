//
//  PersonViewControllerDataSource.h
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PersonContainer.h"
#import "ContactsBaseDataSource.h"
#import "FavoritePhoneContainer.h"

@interface PersonDataSource : ContactsBaseDataSource <UITableViewDataSource, ToggleDelegate>
{
    PersonContainer         *_person;
    FavoritePhoneContainer  *_favorites;
}

@property (retain, nonatomic) PersonContainer           *person;
@property (retain, nonatomic) FavoritePhoneContainer    *favorites;

- (BOOL) favoritesModified;

- (NSDictionary *)nameAndPhoneNumberAtIndexPath:(NSIndexPath *)indexPath;

@end
