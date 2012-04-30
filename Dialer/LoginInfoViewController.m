//
//  LoginInfoViewController.m
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "LoginInfoViewController.h"
#import "Constants.h"


@interface LoginInfoViewController ()

@end

@implementation LoginInfoViewController

@synthesize loginDataSource = _loginDataSource;
@synthesize tableView = _tableView;

- (void)loadView
{
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // create the table view to show the Contacts stored on the device.
    UITableView *table = [[UITableView alloc] initWithFrame:appRect style:UITableViewStyleGrouped];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    table.delegate = self;
    LoginInfoViewDataSource *loginInfoDS = [[LoginInfoViewDataSource alloc] init];
    table.dataSource = loginInfoDS;
    [loginInfoDS release];
    
    // save the tableView variable, cause we will need it
    self.tableView = table;
    
    // cause the table to load
    [table reloadData];
    
    // set the table as the view
    self.view = table;
    
    // release the tableView as it is now being held as the View
    [table release];}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    // Create instance of keychain wrapper
	secureData = [SecureData current];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(40, 30, 240, 30)];
    [username setBorderStyle:UITextBorderStyleRoundedRect];
    [username setPlaceholder:@"Username"];
    [username setDelegate:self];
    [username setEnablesReturnKeyAutomatically: TRUE];
    [username setReturnKeyType:UIReturnKeyDone];
	[username setAdjustsFontSizeToFitWidth:YES];  
    [[self view] addSubview:username];  
    
	// Get username from keychain (if it exists)
	[username setText:[secureData userNameValue]];
    NSLog(@"username: %@", [username text]);
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(40, 75, 240, 30)];
    [password setBorderStyle:UITextBorderStyleRoundedRect];
    [password setPlaceholder:@"Password"];
    [password setSecureTextEntry:YES];
    [password setDelegate:self];
    [password setEnablesReturnKeyAutomatically: TRUE];
    [password setReturnKeyType:UIReturnKeyDone];
	[password setAdjustsFontSizeToFitWidth:YES];  
    [[self view] addSubview:password];  
    
	// Get password from keychain (if it exists)  
	[password setText:[secureData passwordValue]];
    NSLog(@"password: %@", [password text]);
    
    testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testButton setFrame:CGRectMake(80, 130, 160, 40)];
	[testButton setTitle:@"Save to Keychain" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside];        
    [[self view] addSubview:testButton];
    
    resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [resetButton setFrame:CGRectMake(80, 185, 160, 40)];
    [resetButton setTitle:@"Reset Keychain" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetPressed:) forControlEvents: UIControlEventTouchUpInside];        
    [[self view] addSubview:resetButton];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	if (indexPath.section != kShowCleartextSection)
	{
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
		// id secAttr = [self.loginDataSource secAttrForSection:indexPath.section];
        
        /*
		[textFieldController.textControl setPlaceholder:[self titleForSection:indexPath.section]];
		[textFieldController.textControl setSecureTextEntry:(indexPath.section == kPasswordSection || indexPath.section == kAccountNumberSection)];
		if (indexPath.section == kUsernameSection || indexPath.section == kPasswordSection)
		{
			textFieldController.keychainItemWrapper = passwordItem;
		}
		else {
			textFieldController.keychainItemWrapper = accountNumberItem;
		}
		textFieldController.textValue = [textFieldController.keychainItemWrapper objectForKey:secAttr];
		textFieldController.editedFieldKey = secAttr;
		textFieldController.title = [DetailViewController titleForSection:indexPath.section];
		
		[self.navigationController pushViewController:textFieldController animated:YES];
         
         */
	}
}

@end
