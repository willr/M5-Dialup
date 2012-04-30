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
static NSInteger kPasswordTag = 2;


@implementation LoginInfoViewDataSource

@synthesize tableView = _tableView;

- (void) dealloc
{
    
    // release allocated resources
    self.tableView = nil;
    [super dealloc];
}


- (NSString *)titleForSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section)
    {
        case kUsernameSection: title = UserNameName;
        case kPasswordSection: title = PasswordName;
        case kAccountNumberSection: title = CallbackNumberName;
    }
    return title;
}

- (id) secAttrForSection:(NSInteger)section
{
    id secAttr = nil;
    
    switch (section)
    {
        case kUsernameSection: secAttr = (id)kSecAttrAccount;
        case kPasswordSection: secAttr = (id)kSecValueData;
        case kAccountNumberSection: secAttr = (id)kSecValueData;
    }
    return secAttr;
}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    // 4 sections, one for each property and one for the switch
    return 4;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    // Only one row for each section
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return (section == kAccountNumberSection) ? 48.0 : 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title = nil;
	
    /*
	if (section == kAccountNumberSection)
	{
		title = @"AccountNumberShared", @"");
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
	
	switch (indexPath.section)
	{
		case kUsernameSection:
		{
			cell = [aTableView dequeueReusableCellWithIdentifier:kUsernameCellIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUsernameCellIdentifier] autorelease];
			}
			
            /*
			cell.textLabel.text = [passwordItem objectForKey:[DetailViewController secAttrForSection:indexPath.section]];
			cell.accessoryType = (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
			*/
             
			break;
		}
			
		case kPasswordSection:
		case kAccountNumberSection:
		{
			UITextField *textField = nil;
			
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
			
            /*
			KeychainItemWrapper *wrapper = (indexPath.section == kPasswordSection) ? passwordItem : accountNumberItem;
			textField.text = [wrapper objectForKey:[DetailViewController secAttrForSection:indexPath.section]];
			cell.accessoryType = (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            */
			break;
		}
            
		case kShowCleartextSection:
		{
			cell = [aTableView dequeueReusableCellWithIdentifier:kSwitchCellIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSwitchCellIdentifier] autorelease];
				
				cell.textLabel.text = NSLocalizedString(@"Show Cleartext", @"");
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
				UISwitch *switchCtl = [[[UISwitch alloc] initWithFrame:CGRectMake(194, 8, 94, 27)] autorelease];
				[switchCtl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:switchCtl];
			}
			
			break;
		}
	}
    
	return cell;
}




@end















//
