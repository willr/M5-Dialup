//
//  EditorViewController.h
//  Dialer
//
//  Created by William Richardson on 5/1/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SecureData.h"

typedef void (^SecureDataForKey)(NSString *);

@interface EditorViewController : UIViewController
{
    NSString            *_textValue;
    NSString            *_placeHolder;
    
    UITextField         *_textControl;
    SecureDataForKey    _secureData;
}

@property (nonatomic, retain) NSString          *textValue;
@property (nonatomic, retain) NSString          *placeHolder;
@property (nonatomic, retain) UITextField       *textControl;

- (void) cancel:(id)sender;

- (void) save:(id)sender;

- (void) setSecureDataUpdater:(SecureDataForKey)updater;

@end
