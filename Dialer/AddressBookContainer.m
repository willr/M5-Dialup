//
//  AddressBookContainer.m
//  
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressBookContainer.h"

@implementation AddressBookContainer

@synthesize delegate = _delegate;

- (NSString *)getPhoneLabelForDisplay:(NSString *)label
{
    NSRange foundRange = [label rangeOfString:@"work"
                                      options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"Work";
    }
    
    foundRange = [label rangeOfString:@"mobile"
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"Mobile";
    }
    
    foundRange = [label rangeOfString:@"iphone"
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"iPhone";
    }
    
    foundRange = [label rangeOfString:@"home"
                              options:NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        return @"Home";
    }
    
    return nil;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    [self.delegate checkButtonTapped:sender event:event];
}

- (UIButton *)createCallButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    callButton.frame = frame;
    
    [callButton setTitle:@"Call" forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

- (UIButton *)createFavoriteButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(165.0, 7.0, 65.0, 30.0);
    callButton.frame = frame;
    
    [callButton setTitle:@"Favorite" forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

@end
