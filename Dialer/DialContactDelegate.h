//
//  DialContact.h
//  Dialer
//
//  Created by William Richardson on 4/8/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DialContactDelegate.h"

@protocol DialContactDelegate <NSObject>

- (void)connectWithContact:(NSString *)contactName phoneNumber:(NSString *)phoneNumber;

@optional

@end
