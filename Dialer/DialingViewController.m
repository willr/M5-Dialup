//
//  DialingViewController.m
//  Dialer
//
//  Created by William Richardson on 3/24/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "DialingViewController.h"
#import "LoginInfoViewController.h"
#import "Constants.h"
#import "M5NetworkConnection.h"

@interface DialingViewController ()

@end

@implementation DialingViewController

@synthesize delegate = _delegate;
@synthesize dialingDS = _dialingDS;
@synthesize tableView = _tableView;
@synthesize retryConnect = _retryConnect;
@synthesize retryView = _retryView;
@synthesize m5Connect = _m5Connect;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        
        _dialingDS = [[DialingDataSource alloc] init];
    }
    return self;
}

- (void) dealloc
{
    self.delegate = nil;
    self.dialingDS = nil;
    self.tableView = nil;
    self.retryConnect = nil;
    self.retryView = nil;
    self.m5Connect = nil;
    
    [super dealloc];
}

- (void) loadLoginInfoView
{
    // NSLog(@"Invalid Login Info, confirming with User.");
    
    // load the loginViewController, pushing onto the NavController stack
    LoginInfoViewController *loginController = [[LoginInfoViewController alloc] init];
    loginController.loginDelegate = self;
    
    [self.navigationController pushViewController:loginController animated:YES];
    
    [loginController release];
}

- (void) loadView
{
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // create the table view to show the Contacts stored on the device.
    UITableView *table = [[UITableView alloc] initWithFrame:appRect style:UITableViewStyleGrouped];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // set the UITableViewDelegate
    table.delegate = self;
    // set the tableView dataSource delegate
    table.dataSource = self.dialingDS;
    
    // save the tableView variable, cause we will need it
    self.tableView = table;
    
    // set the table as the view
    self.view = table;
    
    // release the tableView as it is now being held as the View
    [table release];
    
    // add Cancel button
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                   target:self 
                                                                                   action:@selector(cancelButtonPressed:event:)] autorelease]; 
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // add edit button
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                                 target:self 
                                                                                 action:@selector(editButtonPressed:event:)] autorelease]; 
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Create instance of keychain wrapper
	secureData = [SecureData current];
    
    // Get username from keychain (if it exists)
	NSString *sourcePhone = [secureData sourcePhoneNumberValue];
    // NSLog(@"username: %@", userName);
    
    // Get password from keychain (if it exists)  
	NSString *password = [secureData passwordValue];
    // NSLog(@"password: %@", password);
    
    if ([sourcePhone length] == 0 || [password length] == 0 ) {
        [self loadLoginInfoView];
    }
    
    if (!_cancelled) {
        [self.delegate callRequestSent];
    }
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // default cancelled to false, when view appears
    _cancelled = false;
    
    self.retryConnect.titleLabel.text = @"Call Phone Number";
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) cancelConnection
{
    self.retryConnect.titleLabel.text = @"Retry Phone Number";
    
    // set cancelled status, reload table
    self.dialingDS.status = kCancelledConnection;
    [self.tableView reloadData];
}

- (void) startConnection
{
    // set connection status, reload table
    self.dialingDS.status = kConnectingConnection;
    [self.tableView reloadData];
    
    [self networkConnectionDial];
}

- (void) networkConnectionDial
{
    // start the network connection and dial the call
    _m5Connect = [[M5NetworkConnection alloc] init];
    
    self.m5Connect.connDelegate = self;
    
    [self.m5Connect dialPhoneNumber:self.dialingDS.phoneNumberDigits];
}

- (void) cancelButtonPressed:(id)sender event:(id)event
{
    // call cancelled method, to handle all actions when this occures
    [self cancelConnection];
    _cancelled = true;
    
    // notify parent view Controller
    [self.delegate callRequestCancelled];
}

- (void) editButtonPressed:(id)sender event:(id)event
{
    // call cancelled method, to handle all actions when this occures
    [self cancelConnection];
    
    // load the loginInfo view to set parameters
    [self loadLoginInfoView];
}

- (void) retryButtonPressed:(id)sender event:(id)event
{
    // start the call 
    [self startConnection];
    
}

// create the retry button that appears in the footer
- (UIButton *) createRetryButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(retryButtonPressed:event:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Call Phone Number" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 40.0, 160.0, 42.0);
    button.tintColor = [UIColor blueColor];
    
    return button;
}

#pragma mark - DialingNetConnectionDelegate

- (void) updateDialingStatus:(ConnectionStatus)status forNumber:(NSString *)destPhone
{
    // set connection status, reload table
    self.dialingDS.status = status;
    [self.tableView reloadData];
}

#pragma mark - LoginViewDelegate

- (void) loginInfoEntered
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loginInfoEntryCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cause the cell to deselect animated, nicely when released
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.section == kRetryConnection) {
        [self startConnection];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // add enough height for the button below
    return (section == kProgressIndictor) ? 82.0 : 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // not sure this is right, but the important thing, is dont add a view unless it is the progressIndicator sections
    if (section != kProgressIndictor) {
        return [self.tableView tableFooterView];
    }
    
    // create the retryView if we have not been here before
    if (self.retryView == nil) {
        UIButton *retryButton = [self createRetryButton];
        // create a view to house the button, without this, it only seemed to default to full width of screen
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(80.0, 40.0, 160.0, 42.0)];
        [buttonView addSubview:retryButton];
        
        // save for later, or next pass through heres
        self.retryConnect = retryButton;
        self.retryView = buttonView;
        
        // release as we have already retained in prop, button is autoReleased, I think
        [buttonView release];
    }
    
    return self.retryView;
}

@end














//