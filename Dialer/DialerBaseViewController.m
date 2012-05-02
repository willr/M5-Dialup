//
//  DialerBaseViewController.m
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "DialerBaseViewController.h"
#import "DialingViewController.h"
#import "Constants.h"

@implementation DialerBaseViewController

- (NSIndexPath *) indexPathForButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView 
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
    
    return indexPath;
}

- (void)connectWithContact:(NSDictionary *)callInfo  delegate:(id<DialingViewDelegate>)delegate
{
    
    DialingViewController *dialing = [[DialingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dialing];
    
    NSLog(@"callInfo: %@", callInfo);
    dialing.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    dialing.delegate = delegate;
    [dialing.dialingDS setPhoneInfo:callInfo];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    [nav release];
    
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
