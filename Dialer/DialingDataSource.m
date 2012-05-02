//
//  DialingDataSource.m
//  Dialer
//
//  Created by William Richardson on 5/1/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DialingDataSource.h"
#import "Constants.h"

@implementation DialingDataSource

@synthesize nameToCall = _nameToCall;
@synthesize phoneToCall = _phoneToCall;
@synthesize phoneTypeToCall = _phoneTypeToCall;

@synthesize status = _status;

- (void) dealloc
{
    self.nameToCall = nil;
    self.phoneToCall = nil;
    self.phoneTypeToCall = nil;
    
    [super dealloc];
}

- (void) setPhoneInfo:(NSDictionary *)phoneInfo
{
    self.nameToCall = [phoneInfo objectForKey:PersonName];
    self.phoneToCall = [phoneInfo objectForKey:PersonPhoneNumber];
    self.phoneTypeToCall = [phoneInfo objectForKey:PersonPhoneLabel];
    
    self.status = kWaitingToConnect;
}

- (NSString *) convertConnectionStatus:(ConnectionStatus)status
{
    NSString *connectionStatus = nil;
    
    switch (status) {
        case kWaitingToConnect:
            connectionStatus = WaitingToConnect;
            break;
        case kConnectingConnection:
            connectionStatus = ConnectingConnection;
            break;
        case kCompletedConnection:
            connectionStatus = CompletedConnection;
            break;
        case kCancelledConnection:
            connectionStatus = CancelledConnection;
            break;
        case kErroredConnection:
            connectionStatus = ErroredConnection;
            break;
        default:
            connectionStatus = @"Error, invalid connection status";
            NSAssert1(false, @"Invalid connection status: %@", status);
            break;
    }
    
    return connectionStatus;
}

- (NSString *) titleForHeaderSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case kCallingName:
            title = CallingName;
            break;
        case kPhoneNumberCalling:
            title = PhoneNumberCalling;
            break;
        case kRetryConnection:
            title = @"";
            break;
        case kProgressIndictor:
            title = ProgressIndicator;
            break;
    }
    
    return title;
}

#pragma mark -
#pragma mark - <UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    // 4 sections, Name to call, phone number called with phoneType, progress indicator
    return 3;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    // Only one row for each section
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForHeaderSection:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *kCallingNameIdentifier =	@"CallingNameCell";
	static NSString *kPhoneNumberCallingIdentifier =	@"PhoneNumberCallingCell";
	static NSString *kBlankIdentifier =	@"BlankCell";
    static NSString *kProgressIndictorIdentifier =	@"ProgressCell";
	
	UITableViewCell *cell = nil;	
	switch (indexPath.section)
	{
        case kCallingName:
        {
            cell = [aTableView dequeueReusableCellWithIdentifier:kCallingNameIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCallingNameIdentifier] autorelease];
			}
			
            cell.textLabel.text = self.nameToCall;
            
            break;
        }
        case kPhoneNumberCalling:
        {
            cell = [aTableView dequeueReusableCellWithIdentifier:kPhoneNumberCallingIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPhoneNumberCallingIdentifier] autorelease];
			}
			
            NSString *textValue = [NSString stringWithFormat:@"[%@] %@", self.phoneTypeToCall, self.phoneToCall];
            cell.textLabel.text = textValue;
            
            break;
        }
        case kRetryConnection:
        {
            
            cell = [aTableView dequeueReusableCellWithIdentifier:kBlankIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBlankIdentifier] autorelease];
			}

            // NSLog(@"tag: %d", cell.tag);
            if (cell.tag == self.status) {
                return cell;
            }
            
            switch (self.status) {
                case kWaitingToConnect:
                case kConnectingConnection:
                {
                    // [[[cell.contentView subviews] objectAtIndex:0] removeFromSuperview];
                    cell.textLabel.text = @"";
                    cell.textLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    break;
                }
                case kCompletedConnection:
                case kCancelledConnection:
                case kErroredConnection:
                {
                    // UIButton *retryButton = [self newRetryButton];
                    // [cell.contentView addSubview:retryButton ];
                    cell.textLabel.text = @"Retry Call";
                    cell.textLabel.textAlignment = UITextAlignmentCenter;
                    cell.textLabel.backgroundColor = [UIColor lightGrayColor];
                    break;
                }
            }
            cell.tag = self.status;
            
            break;
        }
        case kProgressIndictor:
        {
            cell = [aTableView dequeueReusableCellWithIdentifier:kProgressIndictorIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProgressIndictorIdentifier] autorelease];
			}
            
            cell.textLabel.text = [self convertConnectionStatus:self.status];
            _statusModified = false;
            
            break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end

















//