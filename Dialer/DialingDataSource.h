//
//  DialingDataSource.h
//  Dialer
//
//  Created by William Richardson on 5/1/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "M5ResponseMessage.h"

@interface DialingDataSource : NSObject <UITableViewDataSource>
{
    NSString            *_nameToCall;
    NSString            *_phoneToCall;
    NSString            *_phoneNumberDigits;
    NSString            *_phoneTypeToCall;
    ConnectionStatus    _status;
    NSString            *_connectionStatus;
    BOOL                _statusModified;
    
    M5ResponseMessage  *_responseMessage;
}

@property (nonatomic, retain) NSString          *nameToCall;
@property (nonatomic, retain) NSString          *phoneToCall;
@property (nonatomic, retain) NSString          *phoneNumberDigits;
@property (nonatomic, retain) NSString          *phoneTypeToCall;
@property (nonatomic, assign) ConnectionStatus  status;
@property (nonatomic, retain) M5ResponseMessage *responseMessage;



- (void) setPhoneInfo:(NSDictionary *)phoneInfo;


@end
