//
//  M5ReturnMessage.h
//  Dialer
//
//  Created by William Richardson on 5/14/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

// enum Element;

@interface M5ResponseMessage : NSObject <NSXMLParserDelegate>
{
    NSInteger       _majorErrorCode;
    NSInteger       _minoroErrorCode;
    NSString        *_apiMessage;
    NSUInteger      _errorCount;
    
    
    NSMutableString *_currentContents;
}

@property (nonatomic) NSInteger                 majorErrorCode;
@property (nonatomic) NSInteger                 minorErrorCode;
@property (nonatomic, retain) NSString          *apiMessage;
@property (nonatomic) NSUInteger                errorCount;

@property (nonatomic, retain) NSMutableString   *currentContents;

+ (M5ResponseMessage *) parseReturnMessage:(NSData *)receivedData;

@end
