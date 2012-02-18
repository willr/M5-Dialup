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

- (UIButton *)configureCallButton
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

- (NSDictionary *)createNewFavoriteFromContact:(NSDictionary *)person 
                     contactIndex:(int)contactIndex 
                       phoneIndex:(int)phoneIndex
{
    NSMutableDictionary *fav = [[[NSMutableDictionary alloc] init] autorelease];
    NSString * favName = [person objectForKey:@"name"];
    NSMutableDictionary *favPhoneList = [[NSMutableDictionary alloc] init];
    
    [fav setObject:favName forKey:@"name"];
    [fav setObject:favPhoneList forKey:@"phoneList"];
    
    [favPhoneList setObject:[[[person objectForKey:@"phoneList"] allValues] objectAtIndex:phoneIndex]                     
                     forKey:[[[person objectForKey:@"phoneList"] allKeys] objectAtIndex:phoneIndex]];
    
    [favPhoneList release];

    return fav;
}

- (NSNumber *)getFirstFoundPhoneId:(NSDictionary *)person
{
    NSNumber *phoneId = nil;
    BOOL found = false;
    
    NSDictionary *phoneList = [person objectForKey:@"phoneList"];
    NSArray *phoneEntries = [phoneList allValues];
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
        phoneId = [phoneEntry objectForKey:@"phoneId"];
        found = [phoneId isEqualToNumber:phoneId];
        
        if (found) {
            break;
        }
    }
    
    return phoneId;
}

- (BOOL)modifyFavoriteStatusOnPerson:(NSDictionary *)person status:(BOOL)status
{
    BOOL found = false;
    NSDictionary *phoneList = [person objectForKey:@"phoneList"];
    NSArray *phoneEntries = [phoneList allValues];
    NSNumber *phoneId;
    for (NSMutableDictionary *phoneEntry in phoneEntries) {
        phoneId = [phoneEntry objectForKey:@"phoneId"];
        found = [phoneId isEqualToNumber:phoneId];
        [phoneEntry setObject:[NSNumber numberWithBool:status] forKey:@"isFavorite"];
        if (found) {
            break;
        }
    }
    
    return found;
}

- (void)modifyFavoriteStatus:(NSArray *)list phoneId:(NSNumber *)phoneId status:(BOOL)status
{
    BOOL found = false;
    
    for (NSDictionary *person in list) {
        found = [self modifyFavoriteStatusOnPerson:person status:status];
        
        if (found) {
            break;
        }
    }
}

- (BOOL)getFavoriteStatusFromList:(NSArray *)list phoneId:(NSNumber *)phoneId
{
    BOOL found = false;
    BOOL isFavorite = false;
    NSNumber *yesFavorite = [NSNumber numberWithBool:YES];
    
    for (NSDictionary *person in list) {
        NSDictionary *phoneList = [person objectForKey:@"phoneList"];
        NSArray *phoneEntries = [phoneList allValues];
        for (NSDictionary *phoneEntry in phoneEntries) {
            NSNumber *storedPhoneId = [phoneEntry objectForKey:@"phoneId"];
            found = [phoneId isEqualToNumber:storedPhoneId];
            if (found) {
                NSNumber *isFavoriteStored = [phoneEntry objectForKey:@"isFavorite"];
                isFavorite = [isFavoriteStored isEqualToNumber:yesFavorite];;
                break;
            }
        }
        
        if (found) {
            break;
        }
    }
    
    return isFavorite;
}

@end
