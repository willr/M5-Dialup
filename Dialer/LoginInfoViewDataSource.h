//
//  LoginInfoViewDataSource.h
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoginInfoViewController.h"

@class LoginInfoViewController;

@interface LoginInfoViewDataSource : NSObject <UITableViewDataSource>
{
    LoginInfoViewController *_controller;
    
    BOOL                    _editing;
}

// this will be a weak reference back to the controller, so we can set the selector on the action sheet
@property (nonatomic, assign) LoginInfoViewController *controller;

- (NSString *)valueForSection:(NSInteger)section;

- (NSString *)titleForSection:(NSInteger)section;

- (id) secAttrForSection:(NSInteger)section;
   
@end















//