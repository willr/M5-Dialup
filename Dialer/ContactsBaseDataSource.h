//
//  ContactsBaseDataSource.h
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallButtonDelegate.h"

@interface ContactsBaseDataSource : NSObject
{
    id _callButtonDelegate;
}

@property (strong, nonatomic) id<CallButtonDelegate> callButtonDelegate;

- (UIButton *) configureCallButton;

- (UIButton *) createFavoriteButton;

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

- (void)checkButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView;

@end
