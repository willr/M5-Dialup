//
//  DialingDetailsViewController.h
//  Dialer
//
//  Created by William Richardson on 5/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialingDetailsViewController : UIViewController
{
    NSString    *_textValue;
    NSString    *_headerTxt;
    
    UITextView  *_textView;
    UILabel     *_sectionLabel;
}

@property (nonatomic, retain) NSString      *textValue;
@property (nonatomic, retain) NSString      *headerTxt;
@property (nonatomic, retain) UITextView    *textView;
@property (nonatomic, retain) UILabel       *sectionLabel;

@end
