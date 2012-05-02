//
//  IndividualContactViewController.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonDataSource.h"
#import "CallButtonDelegate.h"
#import "DialerBaseViewController.h"

@interface PersonViewController : DialerBaseViewController <UITableViewDelegate, CallButtonDelegate>
{
    PersonDataSource    *_person;
    UITableView         *_tableView;
}

@property (retain, nonatomic) PersonDataSource  *person;
@property (retain, nonatomic) UITableView       *tableView;

- (void)checkButtonTapped:(id)sender event:(id)event;

@end
