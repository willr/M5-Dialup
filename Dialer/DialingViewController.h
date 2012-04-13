//
//  DialingViewController.h
//  Dialer
//
//  Created by William Richardson on 3/24/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecureData.h"
#import "DialContactDelegate.h"

@interface DialingViewController : UIViewController <UITextFieldDelegate, DialContactDelegate>
{
    UILabel         *message;
    UILabel         *contactDialed;
    UILabel         *progress;
    
    NSString        *userName;
    NSString        *password;
    
    UIButton        *cancelButton;
    
    SecureData      *secureData;
}

@end
