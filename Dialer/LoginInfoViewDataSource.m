//
//  LoginInfoViewDataSource.m
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "LoginInfoViewDataSource.h"

#import "Constants.h"

// Defined UI Constants

// tag table view cells that contain a text field to support secure text entry


@implementation LoginInfoViewDataSource

@synthesize controller = _controller;

- (void) dealloc
{
    self.controller = nil;
    
    [super dealloc];
}

// call the correct SecureData method for the section being displayed
- (NSString *)valueForSection:(NSInteger)section
{
    NSString *textValue = nil;
    switch (section)
    {
        case kUsernameSection: textValue = [[SecureData current] userNameValue];
            break;
        case kPasswordSection: textValue = [[SecureData current] passwordValue];
            break;
        case kSourcePhoneNumberSection: textValue = [[SecureData current] sourcePhoneNumberValue];
            break;
    }
    return textValue;
}

// title for each section being displayed
- (NSString *)titleForSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section)
    {
        case kUsernameSection: title = UserNameName;
            break;
        case kPasswordSection: title = PasswordName;
            break;
        case kSourcePhoneNumberSection: title = CallbackNumberName;
            break;
    }
    return title;
}

/*
- (id) secAttrForSection:(NSInteger)section
{
    id secAttr = nil;
    
    switch (section)
    {
        case kUsernameSection: secAttr = (id)kSecAttrAccount;
            break;
        case kPasswordSection: secAttr = (id)kSecValueData;
            break;
        case kSourcePhoneNumberSection: secAttr = (id)kSecValueData;
            break;
    }
    return secAttr;
}
*/

#pragma mark -
#pragma mark <UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    // 4 sections, one for each property and one for the switch, (password, source phoneNumber, switch)
    return 3;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    // Only one row for each section
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return (section == kSourcePhoneNumberSection) ? 48.0 : 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title = nil;
	/*
	if (section == kSourcePhoneNumberSection)
	{
		title = @"AccountNumberShared";
	}
    */
	return title;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *kUsernameCellIdentifier =	@"UsernameCell";
	static NSString *kPasswordCellIdentifier =	@"PasswordCell";
	static NSString *kSwitchCellIdentifier =	@"SwitchCell";
	
	UITableViewCell *cell = nil;	
	
    // based on section number, create the correct TableViewCell
	switch (indexPath.section)
	{
		case kUsernameSection:
		{
			cell = [aTableView dequeueReusableCellWithIdentifier:kUsernameCellIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUsernameCellIdentifier] autorelease];
			}
			
            // set userName to be displayed
            cell.textLabel.text = [self valueForSection:indexPath.section];
			cell.accessoryType = (_editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
             
			break;
		}
			
		case kPasswordSection:
		case kSourcePhoneNumberSection:
		{
			UITextField *textField = nil;
			// create a textField to for the cells, contentView, and enable secureText (bullets)
			cell = [aTableView dequeueReusableCellWithIdentifier:kPasswordCellIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPasswordCellIdentifier] autorelease];
                
				textField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 10, 10)];
				textField.tag = kPasswordTag;
				textField.font = [UIFont systemFontOfSize:17.0];
				
				// prevent editing
				textField.enabled = NO;
				
				// display contents as bullets rather than text
				textField.secureTextEntry = YES;
				
				[cell.contentView addSubview:textField];
				[textField release];
			}
			else {
				textField = (UITextField *) [cell.contentView viewWithTag:kPasswordTag];
			}
            
			// set the current value
            cell.accessoryType = (_editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            textField.text = [self valueForSection:indexPath.section];
            
			break;
		}
            
		case kShowCleartextSection:
		{
			cell = [aTableView dequeueReusableCellWithIdentifier:kSwitchCellIdentifier];
			if (cell == nil)
			{
                // create and add a Switch for enable clear text display on the secureFields
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSwitchCellIdentifier] autorelease];
				
				cell.textLabel.text = NSLocalizedString(@"Show Cleartext", @"");
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
				UISwitch *switchCtl = [[[UISwitch alloc] initWithFrame:CGRectMake(194, 8, 94, 27)] autorelease];
				[switchCtl addTarget:self.controller action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:switchCtl];
			}
			
			break;
		}
	}
    
	return cell;
}




@end















//
