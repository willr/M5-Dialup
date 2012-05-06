//
//  DialingNetConnectionDelegate.h
//  Dialer
//
//  Created by William Richardson on 5/5/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@protocol DialingNetConnectionDelegate <NSObject>

- (void) updateDialingStatus:(ConnectionStatus)status forNumber:(NSString *)destPhone;

@end
