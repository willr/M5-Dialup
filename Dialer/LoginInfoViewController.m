//
//  LoginInfoViewController.m
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "LoginInfoViewController.h"
#import "Constants.h"
#import "EditorViewController.h"
#import "LoginInfoViewDataSource.h"

@interface LoginInfoViewController ()

@end

@implementation LoginInfoViewController

@synthesize loginDataSource = _loginDataSource;
@synthesize tableView = _tableView;
@synthesize loginDelegate = _loginDelegate;

- (void) dealloc
{
    self.loginDataSource = nil;
    self.loginDelegate = nil;
    self.tableView = nil;
    
    [super dealloc];
}

- (void)loadView
{
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // create the table view to show the Contacts stored on the device.
    UITableView *table = [[UITableView alloc] initWithFrame:appRect style:UITableViewStyleGrouped];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    table.delegate = self;
    _loginDataSource = [[LoginInfoViewDataSource alloc] init];
    table.dataSource = self.loginDataSource;
    
    // save the tableView variable, cause we will need it
    self.tableView = table;
    
    // set the table as the view
    self.view = table;
    
    // release the tableView as it is now being held as the View
    [table release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// clearText switch selector target, turn off secureTextEntry hiding the actual values, and display clearText or reverse
- (void)switchAction:(id)sender
{
    // find the password cell, and turn off secureText entry
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:
							 [NSIndexPath indexPathForRow:0 inSection:kPasswordSection]];
	UITextField *textField = (UITextField *) [cell.contentView viewWithTag:kPasswordTag];
	textField.secureTextEntry = ![sender isOn];
	
    // find the sourcePhoneNumber cell, and turn off secureText entry
	cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kSourcePhoneNumberSection]];
	textField = (UITextField *) [cell.contentView viewWithTag:kPasswordTag];
	textField.secureTextEntry = ![sender isOn];
}

#pragma mark - UIActionSheetDelegate
// Action sheet delegate method.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        // reset the secureData, clearing out the current values
        [[SecureData current] reset];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
// upon selection of a row, push the editorViewController to allow editing of the current value
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    // if not the clearText switch section, get the stored secureData value
	if (indexPath.section != kShowCleartextSection)
	{
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        SecureDataForKey setSecureData = nil;
        NSString *textValue = nil;
        SecureData *secureData = [SecureData current];
        
        // build a block to set the correct value back by the correct method
        switch (indexPath.section)
        {
            case kUsernameSection:
                setSecureData = ^(NSString *txtValue) {
                    [secureData setUserNameValue:txtValue];
                };
                textValue = [secureData userNameValue];
                break;
            case kPasswordSection:
                setSecureData = ^(NSString *txtValue) {
                    [secureData setPasswordValue:txtValue];
                };
                textValue = [secureData passwordValue];
                break;
            case kSourcePhoneNumberSection:
                setSecureData = ^(NSString *txtValue) {
                    [secureData setSourcePhoneNumberValue:txtValue];
                };
                textValue = [secureData sourcePhoneNumberValue];
                break;
        }
        
        // create the editor control, set the values to be displayed
        EditorViewController *editor = [[EditorViewController alloc] init];
        
        // placeholder and title should be the same, and the name of the item being edited
        editor.placeHolder = [self.loginDataSource titleForSection:indexPath.section];
        editor.title = [self.loginDataSource titleForSection:indexPath.section];
        
        // set the updater block, this must be done as a copy, the property being set with the block must have copy attrib, 
        //      or bad_exec, as the stack vars will be gone
        [editor setSecureDataUpdater:setSecureData];
        editor.textValue = textValue;
        
        // push the editor ViewController to show user
        [self.navigationController pushViewController:editor animated:YES];
        [editor release];
	}
}

@end
