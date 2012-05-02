//
//  DialingDataSource.h
//  Dialer
//
//  Created by William Richardson on 5/1/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DialingDataSource : NSObject <UITableViewDataSource>
{
    NSString            *_nameToCall;
    NSString            *_phoneToCall;
    NSString            *_phoneTypeToCall;
    ConnectionStatus    _status;
    NSString            *_connectionStatus;
    BOOL                _statusModified;
    
    
}

@property (nonatomic, retain) NSString          *nameToCall;
@property (nonatomic, retain) NSString          *phoneToCall;
@property (nonatomic, retain) NSString          *phoneTypeToCall;
@property (nonatomic, assign) ConnectionStatus  status;



- (void) setPhoneInfo:(NSDictionary *)phoneInfo;


@end
