//
//  ContactsViewController.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactListContainer.h"
#import "CallButtonDelegate.h"

@interface ContactsViewController : UIViewController <UITableViewDelegate, CallButtonDelegate>
{
    ContactListContainer *_addresses;
    UITableView *_tableView;
}

@property (strong, nonatomic) ContactListContainer *addresses;
@property (strong, nonatomic) UITableView *tableView;

@end
