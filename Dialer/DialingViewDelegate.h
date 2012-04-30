//
//  DialingViewDelegate.h
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DialingViewDelegate <NSObject>

- (void) callRequestSent;

- (void) callRequestCancelled;

@end
