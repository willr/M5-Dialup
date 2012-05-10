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
@synthesize phoneNumberDigits = _phoneNumberDigits;
@synthesize phoneTypeToCall = _phoneTypeToCall;

@synthesize status = _status;

- (void) dealloc
{
    self.nameToCall = nil;
    self.phoneToCall = nil;
    self.phoneNumberDigits = nil;
    self.phoneTypeToCall = nil;
    
    [super dealloc];
}

// set phoneInfo for call based on dictionary parameter
- (void) setPhoneInfo:(NSDictionary *)phoneInfo
{
    self.nameToCall = [phoneInfo objectForKey:PersonName];
    self.phoneToCall = [phoneInfo objectForKey:PersonPhoneNumber];
    self.phoneNumberDigits = [phoneInfo objectForKey:PersonPhoneNumberDigits];
    self.phoneTypeToCall = [phoneInfo objectForKey:PersonPhoneLabel];
    
    // default to waiting to connect.  This should probably auto connect atsome point.
    // I assume based on an async call, that will update this as it goes along
    //      this is not yet implemented
    self.status = kWaitingToConnect;
}

// convert the ConnectionStatus enum to string representation
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

// title for each section
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
        // dont this we use this now
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
    // 3 sections, Name to call, phone number called with phoneType, progress indicator
    
    // only 3 sections for now, we are skipping the kRetryConnection as we are just putting the button in the footer of ProgressIndicator
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
    // hmm guess I should make constants... 
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
			
            // just set the contact name we are calling
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
			
            // set a formatted phone number with phone type
            NSString *textValue = [NSString stringWithFormat:@"[%@] %@", self.phoneTypeToCall, self.phoneToCall];
            cell.textLabel.text = textValue;
            
            break;
        }
        case kRetryConnection:
        {
            // all this is ignored for now, as we setup the button in the footer.  delete in the future
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
            
            // translate the status enum into string representation
            cell.textLabel.text = [self convertConnectionStatus:self.status];
            _statusModified = false;
            
            break;
        }
    }
    
    // dont show the blue cell selected value
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end

















//