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

@interface DialingViewController ()

@end

@implementation DialingViewController

@synthesize delegate = _delegate;
@synthesize dialingDS = _dialingDS;
@synthesize tableView = _tableView;
@synthesize retryConnect = _retryConnect;
@synthesize retryView = _retryView;

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
    self.retryConnect = nil;
    self.dialingDS = nil;
    self.tableView = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void) loadLoginInfoView
{
    NSLog(@"Invalid Login Info, confirming with User.");
    
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
    
    table.delegate = self;
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
    
    // add Cancel button
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
	NSString *userName = [secureData userNameValue];
    NSLog(@"username: %@", userName);
    
    // Get password from keychain (if it exists)  
	NSString *password = [secureData passwordValue];
    NSLog(@"password: %@", password);
    
    if (userName  == nil || [userName isEqualToString:@""] || password == nil || [password isEqualToString:@""] ) {
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
    
    _cancelled = false;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) cancelConnection
{
    self.dialingDS.status = kCancelledConnection;
    [self.tableView reloadData];
}

- (void) startConnection
{
    self.dialingDS.status = kConnectingConnection;
    [self.tableView reloadData];
}

- (void) cancelButtonPressed:(id)sender event:(id)event
{
    [self cancelConnection];
    _cancelled = true;
    
    [self.delegate callRequestCancelled];
}

- (void) editButtonPressed:(id)sender event:(id)event
{
    [self cancelConnection];
    
    [self loadLoginInfoView];
}

- (void) retryButtonPressed:(id)sender event:(id)event
{
    [self startConnection];
    
}

- (UIButton *) createRetryButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(retryButtonPressed:event:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Retry Connection" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 40.0, 160.0, 42.0);
    button.tintColor = [UIColor blueColor];
    // button.showsTouchWhenHighlighted = YES;
    
    return button;
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
    return (section == kProgressIndictor) ? 82.0 : 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != kProgressIndictor) {
        return [self.tableView tableFooterView];
    }
    
    if (self.retryView == nil) {
        UIButton *retryButton = [self createRetryButton];
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(80.0, 40.0, 160.0, 42.0)];
        [buttonView addSubview:retryButton];
        
        self.retryConnect = retryButton;
        self.retryView = buttonView;
        
        [buttonView release];
    }
    
    return self.retryView;
}

@end














//