//
//  ContactsBaseDataSource.m
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ContactsBaseDataSource.h"
#import "Constants.h"
#import "DialingViewController.h"

@implementation ContactsBaseDataSource

@synthesize callButtonDelegate = _callButtonDelegate;

// create the Call button in the row, this is just a factory method
- (UIButton *)configureCallButton:(id<CallButtonDelegate>)callButtonDelegate
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    callButton.frame = frame;
    
    // we use delegate, as we are setting the viewController to receive the button press
    [callButton setTitle:CallButtonTitle forState:UIControlStateNormal];
    [callButton addTarget:callButtonDelegate action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

// create the favorites button to enable a contract to be a "favorite" or "un-favorite" a contact
- (UIButton *)createFavoriteButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(165.0, 7.0, 65.0, 30.0);
    callButton.frame = frame;
    
    // using self as the target, as the dataSource handles the favorite/un-favorite mechanism
    [callButton setTitle:FavoriteButtonTitle forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

@end
