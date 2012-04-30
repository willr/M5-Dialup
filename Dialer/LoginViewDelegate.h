//
//  LoginViewDelegate.h
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginViewDelegate <NSObject>

- (void) loginInfoEntered;

- (void) loginInfoEntryCancelled;

@end
