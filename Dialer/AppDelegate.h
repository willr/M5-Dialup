//
//  AppDelegate.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDefaultsContainer.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // UserDefaultsContainer *_appDefaults;
}

@property (retain, nonatomic) UIWindow              *window;
// @property (retain, nonatomic) UserDefaultsContainer *appDefaults;

void onUncaughtException(NSException* exception);

- (void) displayErrorMessage:(NSString *)title additionalInfo:(NSString *)addInfo withError:(NSError *)error;

@end
