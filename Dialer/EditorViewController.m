//
//  EditorViewController.m
//  Dialer
//
//  Created by William Richardson on 5/1/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "EditorViewController.h"

@implementation EditorViewController

@synthesize textValue = _textValue;
@synthesize placeHolder = _placeHolder;
@synthesize textControl = _textControl;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    self.textValue = nil;
    self.placeHolder = nil;
    self.textControl = nil;
    
    // we set the var via method, so manually release and nil
    [_secureData release];
    _secureData = nil;
    
    [super dealloc];
}

// set the block we are going to use to update the value
- (void) setSecureDataUpdater:(SecureDataForKey)updater
{
    _secureData = [updater copy];
}

- (void) loadView
{
    UIView *view = [[UIView alloc] init];
    
    self.view = view;
    [view release];
    
    // add Cancel button
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                   target:self 
                                                                                   action:@selector(cancel:)] autorelease]; 
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // add Save button
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                                   target:self 
                                                                                   action:@selector(save:)] autorelease]; 
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.title = self.placeHolder;
}

- (void) viewDidLoad
{
    _textControl = [[UITextField alloc] initWithFrame:CGRectMake(40, 75, 240, 30)];
    [self.view addSubview:self.textControl];
    [self.textControl setFont:[UIFont boldSystemFontOfSize:16]];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.textControl.backgroundColor = [UIColor whiteColor];
    self.textControl.borderStyle = UITextBorderStyleRoundedRect;
    self.textControl.text = self.textValue;
    self.textControl.placeholder = self.placeHolder;
}

// cancel target for button
- (void) cancel:(id)sender
{
    // cancel edits
    [self.navigationController popViewControllerAnimated:YES];
}

// save target for button
- (void) save:(id)sender
{
    // save edits
    NSString *text = [self.textControl text];
    _secureData(text);
    
    // pop the view back to login, after we have saved
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    // cause the keyboard to appear, when the page is loaded, and set the value
    [self.textControl becomeFirstResponder];
    [self.textControl setText:self.textValue];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
