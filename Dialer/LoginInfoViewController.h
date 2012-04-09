//
//  LoginInfoViewController.h
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecureData.h"

@interface LoginInfoViewController : UIViewController <UITextFieldDelegate>
{
    UITextField         *username;
    UITextField         *password;
	
    UIButton            *testButton;
    UIButton            *resetButton;
    
    SecureData          *secureData;
}

@end
