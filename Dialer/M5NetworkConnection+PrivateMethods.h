//
//  NSObject+M5NetworkConnection_PrivateMethods.h
//  Dialer
//
//  Created by William Richardson on 5/5/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M5NetworkConnection (PrivateMethods)

- (void) networkRequestTo:(NSString *)url;

- (void) updateConnectionStatus:(ConnectionStatus)status forNumber:(NSString *)destPhoneNumber;

- (NSURL *) smartURLForString:(NSString *)str;

@end
