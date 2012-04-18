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

@interface PersonViewController : UIViewController <UITableViewDelegate, CallButtonDelegate>
{
    PersonDataSource             *_person;
    
    id<UITableViewDataSource>   _personDataSource;
    UITableView                 *_tableView;
}

@property (strong, nonatomic) PersonDataSource          *person;

@property (strong, nonatomic) id<UITableViewDataSource> personDataSource;
@property (strong, nonatomic) UITableView               *tableView;

- (void)checkButtonTapped:(id)sender event:(id)event;

@end
