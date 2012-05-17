//
//  DialingDetailsViewController.m
//  Dialer
//
//  Created by William Richardson on 5/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "DialingDetailsViewController.h"

@implementation DialingDetailsViewController

@synthesize textValue = _textValue;
@synthesize headerTxt = _headerTxt;
@synthesize textView = _textView;
@synthesize sectionLabel = _sectionLabel;

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
    self.headerTxt = nil;
    self.textView = nil;
    
    [super dealloc];
}

- (void) loadView
{
    UIView *view = [[UIView alloc] init];
    
    self.view = view;
    [view release];
    
    self.title = self.headerTxt;
}

- (void) viewDidLoad
{
    _sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 300, 40)];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 125, 300, 120)];
    
    [self.view addSubview:self.textView];
    [self.textView setFont:[UIFont boldSystemFontOfSize:16]];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = self.textValue;
    self.textView.editable = NO;
}

@end













