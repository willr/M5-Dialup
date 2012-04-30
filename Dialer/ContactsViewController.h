//
//  ContactsViewController.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactsDataSource.h"

#import "CallButtonDelegate.h"
#import "FavoritePhoneContainer.h"
#import "DialerBaseViewController.h"
#import "DialingViewDelegate.h"


@interface ContactsViewController : DialerBaseViewController <UITableViewDelegate, CallButtonDelegate>
{
    ContactsDataSource *_contacts;
    
    UITableView *_tableView;
    
    id<DialingViewDelegate> _dialerDelegate;
}

@property (retain, nonatomic) ContactsDataSource        *contacts;

@property (assign, nonatomic) UITableView               *tableView;
@property (retain, nonatomic) id<DialingViewDelegate>   dialerDelegate;


@end
