//
//  DialingViewController.m
//  Dialer
//
//  Created by William Richardson on 3/24/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "DialingViewController.h"
#import "LoginInfoViewController.h"

@interface DialingViewController ()

@end

@implementation DialingViewController

@synthesize delegate = _delegate;

- (void)loadLoginInfoView
{
    NSLog(@"Invalid Login Info, confirming with User.");
    
    LoginInfoViewController *loginController = [[LoginInfoViewController alloc] init];
    
    [self.navigationController pushViewController:loginController animated:YES];
    
    [loginController release];
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Create instance of keychain wrapper
	secureData = [SecureData current];
    
    // Get username from keychain (if it exists)
	NSString *userName = [secureData.keychain objectForKey:(id)kSecAttrAccount];
    NSLog(@"username: %@", userName);
    
    // Get password from keychain (if it exists)  
	NSString *password = [secureData.keychain objectForKey:(id)kSecValueData];
    NSLog(@"password: %@", password);
    
    if (userName  == nil || password == nil) {
        [self loadLoginInfoView];
    }
    
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


#pragma mark - LoginViewDelegate

- (void) loginInfoEntered
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loginInfoEntryCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end














//