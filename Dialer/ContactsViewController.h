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

#import "DialContactDelegate.h"


@interface ContactsViewController : UIViewController <UITableViewDelegate, CallButtonDelegate>
{
    ContactsDataSource *_contacts;
    
    UITableView *_tableView;
    
    id<DialContactDelegate> _dialerDelegate;
}

@property (strong, nonatomic) ContactsDataSource        *contacts;

@property (strong, nonatomic) UITableView               *tableView;
@property (strong, nonatomic) id<DialContactDelegate>   dialerDelegate;


@end
