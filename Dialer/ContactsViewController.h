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
#import "DialContactDelegate.h"

@interface ContactsViewController : UIViewController <UITableViewDelegate, CallButtonDelegate>
{
    ContactListContainer *_addresses;
    UITableView *_tableView;
    
    id<DialContactDelegate> _dialerDelegate;
}

@property (retain, strong, nonatomic) ContactListContainer  *addresses;
@property (retain, strong, nonatomic) UITableView           *tableView;
@property (strong, nonatomic) id<DialContactDelegate>       dialerDelegate;


@end
