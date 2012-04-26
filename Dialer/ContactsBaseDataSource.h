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

// use assign and not retain, as we dont want to increase the ref count
@property (assign, nonatomic) id<CallButtonDelegate> callButtonDelegate;

- (UIButton *)configureCallButton:(id<CallButtonDelegate>)callButtonDelegate;

- (UIButton *) createFavoriteButton;

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

- (void)checkButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView;

@end
