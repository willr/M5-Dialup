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
@synthesize secureTextEntry = _secureTextEntry;
@synthesize textControl = _textControl;
// @synthesize secureData = _secureData;

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
    
    [_secureData release];
    _secureData = nil;
    // self.secureData = nil;
    
    [super dealloc];
}

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

- (void) cancel:(id)sender
{
    // cancel edits
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) save:(id)sender
{
    // save edits
    // [self.secureData setObject:[self.textControl text] forKey:self.editedFieldKey];
    NSString *text = [self.textControl text];
    _secureData(text);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textControl becomeFirstResponder];
    [self.textControl setText:self.textValue];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
