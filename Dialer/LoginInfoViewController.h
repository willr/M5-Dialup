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
#import "LoginViewDelegate.h"

@class LoginInfoViewDataSource;

@interface LoginInfoViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate>
{
    LoginInfoViewDataSource *_loginDataSource;
    
    id<LoginViewDelegate>   _loginDelegate;
    UITableView             *_tableView;
}

@property (nonatomic, retain) LoginInfoViewDataSource   *loginDataSource;
@property (nonatomic, retain) id<LoginViewDelegate>     loginDelegate;
@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@end
