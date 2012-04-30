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

@interface DialingViewController : UIViewController <LoginViewDelegate>
{
    SecureData              *secureData;

    id<DialingViewDelegate> _delegate;
    
}

@property (nonatomic, retain) id<DialingViewDelegate>   delegate;

@end
