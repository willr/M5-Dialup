//
//  IndividualContactViewController.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonContainer.h"
#import "CallButtonDelegate.h"

@interface PersonViewController : UIViewController <UITableViewDelegate, CallButtonDelegate>
{
    PersonContainer *_personContainer;
    UITableView *_tableView;
}

@property (strong, nonatomic) PersonContainer *personContainer;
@property (strong, nonatomic) UITableView *tableView;

@end
