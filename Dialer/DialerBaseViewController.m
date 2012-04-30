//
//  DialerBaseViewController.m
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "DialerBaseViewController.h"
#import "DialingViewController.h"

@implementation DialerBaseViewController

- (NSIndexPath *) indexPathForButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView 
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
    
    return indexPath;
}

- (void)connectWithContact:(NSString *)contactName phoneNumber:(NSString *)phoneNumber delegate:(id<DialingViewDelegate>)delegate
{
    DialingViewController *dialing = [[DialingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dialing];
    
    // add Cancel button
    
    dialing.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    dialing.delegate = delegate;
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - DialingViewDelegate

- (void) callRequestSent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) callRequestCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
