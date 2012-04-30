//
//  LoginInfoViewController.h
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecureData.h"
#import "LoginInfoViewDataSource.h"

@interface LoginInfoViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate>
{
    LoginInfoViewDataSource *_loginDataSource;
    
    UITableView *_tableView;
}

@property (nonatomic, retain) LoginInfoViewDataSource *loginDataSource;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
