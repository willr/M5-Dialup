//
//  ContactsBaseDataSource.m
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ContactsBaseDataSource.h"
#import "Constants.h"

@implementation ContactsBaseDataSource

@synthesize callButtonDelegate = _callButtonDelegate;

- (UIButton *)configureCallButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    callButton.frame = frame;
    
    [callButton setTitle:CallButtonTitle forState:UIControlStateNormal];
    [callButton addTarget:self.callButtonDelegate action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

- (UIButton *)createFavoriteButton
{
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(165.0, 7.0, 65.0, 30.0);
    callButton.frame = frame;
    
    [callButton setTitle:FavoriteButtonTitle forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(false, @"This method should be overriden");
}

- (void)checkButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView 
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
    
    // UIButton *button = (UIButton *)sender;
    // UITableViewCell *cell = (UITableViewCell *)[button superview];
    // NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath != nil)
    {
        [self tableView: tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

@end
