//
//  ContactsViewController.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookContainer.h"

@interface ContactsViewController : UIViewController <UITableViewDelegate>
{
    AddressBookContainer *_addresses;
}

@property (strong, nonatomic) AddressBookContainer *addresses;

@end
