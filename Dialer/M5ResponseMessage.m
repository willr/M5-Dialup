//
//  M5ReturnMessage.m
//  Dialer
//
//  Created by William Richardson on 5/14/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "M5ResponseMessage.h"

#import "Constants.h"
#import "TestFlight.h"
#import "AppDelegate.h"

NSString * const M5ErrorCountXmlElement = @"ErrorCount";
NSString * const M5MajorErrorCodeXmlElement = @"MajorErrorCode";
NSString * const M5MinorErrorCodeXmlElement = @"MinorErrorCode";
NSString * const M5ApiMessageXmlElement = @"Message";

enum Element {
    kNone,
    kMajorErrorCode,
    kMinorErrorCode,
    kApiMessage,
    kErrorCount
};

@interface M5ResponseMessage ()
{
    enum Element    _currentElement;
}

@property (nonatomic) enum Element              currentElement;

@end

@implementation M5ResponseMessage

@synthesize majorErrorCode = _majorErrorCode;
@synthesize minorErrorCode = _minoroErrorCode;
@synthesize apiMessage = _apiMessage;
@synthesize errorCount = _errorCount;
@synthesize currentElement = _currentElement;
@synthesize currentContents = _currentContents;

+ (M5ResponseMessage *) parseReturnMessage:(NSData *)receivedData;
{
    M5ResponseMessage *msg = [[[M5ResponseMessage alloc] init] autorelease];
    
    if ([receivedData length]) {
        NSAssert(@"Reeived data size is invalid, size: %d", [[NSNumber numberWithInt:[receivedData length]] stringValue]);
    }
    
    NSXMLParser *msgParser = [[NSXMLParser alloc] initWithData:receivedData];
    msgParser.Delegate = msg;
    [msgParser setShouldProcessNamespaces:NO];
    
    [msgParser parse];
    
    return msg;
}

- (void) dealloc
{
    self.apiMessage = nil;
    self.currentContents = nil;
    
    [super dealloc];
}

#pragma mark - NSXMLParserDelegate

- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName 
     attributes:(NSDictionary *)attributeDict 
{
    if ([elementName isEqualToString:M5ErrorCountXmlElement]) {
        _currentElement = kErrorCount;
        return;
    }
    
    if ([elementName isEqualToString:M5MajorErrorCodeXmlElement]) {
        _currentElement = kMajorErrorCode;
        return;
    }

    if ([elementName isEqualToString:M5MinorErrorCodeXmlElement]) {
        _currentElement = kMinorErrorCode;
        return;
    }

    if ([elementName isEqualToString:M5ApiMessageXmlElement]) {
        _currentElement = kApiMessage;
        return;
    }

}

- (void) parser:(NSXMLParser *)parser 
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName 
{
    switch (self.currentElement) {
        case kErrorCount:
            self.errorCount = [self.currentContents intValue];
            break;
        case kMajorErrorCode:
            self.majorErrorCode = [self.currentContents intValue];
            break;
        case kMinorErrorCode:
            self.minorErrorCode = [self.currentContents intValue];
            break;
        case kApiMessage:
            self.apiMessage = [[self.currentContents copy] autorelease];
            break;
        default:
            NSAssert(@"Invalid Enum value: %@", [[NSNumber numberWithInt:self.currentElement] stringValue]);
            break;
    }
    
    
    
    self.currentElement = kNone;
    [self.currentContents deleteCharactersInRange:NSMakeRange(0, [self.currentContents length])];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.currentContents) {
        // currentStringValue is an NSMutableString instance variable
        self.currentContents = [[[NSMutableString alloc] initWithCapacity:50] autorelease];
    }
    switch (self.currentElement) {
        case kErrorCount:
        case kMajorErrorCode:
        case kMinorErrorCode:
        case kApiMessage:
            [self.currentContents appendString:string];
            break;
        case kNone:
            // do nothing, since this is not an element we care about.
            break;
    }
    
}


- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error Descr %@",parseError.localizedDescription);
    NSLog(@"Error Code %d",parseError.code);    
    NSLog(@"Error Domain %@",parseError.domain);
    
    
    RTFLog(@"parseErrorOccurred, parsing M5 response current element %@, responseMsg: |||%@|||, ERROR:: Error Desc: %@, Error Code: %d, Error Domain: %@", 
           [[NSNumber numberWithInt:self.currentElement] stringValue],
           self.currentContents,
           parseError.localizedDescription, 
           parseError.code, 
           parseError.domain);
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) displayErrorMessage:@"Error reading response from M5" 
                                                                      additionalInfo:@"Try Again" 
                                                                           withError:parseError];

}

@end












//