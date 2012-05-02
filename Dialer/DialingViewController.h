//
//  DialingViewController.h
//  Dialer
//
//  Created by William Richardson on 3/24/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecureData.h"
#import "DialingViewDelegate.h"
#import "LoginViewDelegate.h"
#import "LoginInfoViewController.h"
#import "DialingDataSource.h"

@interface DialingViewController : UIViewController <LoginViewDelegate, UITableViewDelegate>
{
    SecureData              *secureData;
    BOOL                    _cancelled;

    id<DialingViewDelegate> _delegate;
    
    DialingDataSource       *_dialingDS;
    UITableView             *_tableView;
    UIButton                *_retryConnect;
    UIView                  *_retryView;
}

@property (nonatomic, retain) id<DialingViewDelegate>   delegate;
@property (nonatomic, retain) DialingDataSource         *dialingDS;
@property (nonatomic, retain) UITableView               *tableView;
@property (nonatomic, retain) UIButton                  *retryConnect;
@property (nonatomic, retain) UIView                    *retryView;

- (void) cancelConnection;

- (void) loginInfoEntered;

- (void) loginInfoEntryCancelled;

@end
