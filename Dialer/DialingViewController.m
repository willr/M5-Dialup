//
//  DialingViewController.m
//  Dialer
//
//  Created by William Richardson on 3/24/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "DialingViewController.h"

@interface DialingViewController ()

@end

@implementation DialingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadLoginInfoView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Create instance of keychain wrapper
	secureData = [SecureData currentSecureData];
    
    // Get username from keychain (if it exists)
	userName = [secureData.keychain objectForKey:(id)kSecAttrAccount];
    NSLog(@"username: %@", userName);
    
    // Get password from keychain (if it exists)  
	password = [secureData.keychain objectForKey:(id)kSecValueData];
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

#pragma mark - DialContact protocol

- (void)connectWithContact:(NSString *)contactName phoneNumber:(NSString *)phoneNumber
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Initiating call" 
                                                    message:[NSString stringWithFormat:@"Calling %@ with phone number %@", contactName, phoneNumber]
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
