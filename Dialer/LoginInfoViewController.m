//
//  LoginInfoViewController.m
//  Dialer
//
//  Created by William Richardson on 3/21/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "LoginInfoViewController.h"

@interface LoginInfoViewController ()

@end

@implementation LoginInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Create instance of keychain wrapper
	secureData = [SecureData currentSecureData];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(40, 30, 240, 30)];
    [username setBorderStyle:UITextBorderStyleRoundedRect];
    [username setPlaceholder:@"Username"];
    [username setDelegate:self];
    [username setEnablesReturnKeyAutomatically: TRUE];
    [username setReturnKeyType:UIReturnKeyDone];
	[username setAdjustsFontSizeToFitWidth:YES];  
    [[self view] addSubview:username];  
    
	// Get username from keychain (if it exists)
	[username setText:[secureData.keychain objectForKey:(id)kSecAttrAccount]];
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
	[password setText:[secureData.keychain objectForKey:(id)kSecValueData]];
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

@end
