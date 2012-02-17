//
//  CallButtonDelegate.h
//  Dialer
//
//  Created by William Richardson on 2/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CallButtonDelegate <NSObject>

- (void)checkButtonTapped:(id)sender event:(id)event;

@optional

@end
