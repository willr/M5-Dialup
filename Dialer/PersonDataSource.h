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

@property (strong, nonatomic) PersonContainer           *person;
@property (strong, nonatomic) FavoritePhoneContainer    *favorites;

- (BOOL) favoritesModified;

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

@end
