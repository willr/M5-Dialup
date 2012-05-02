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

// get the indexPath for the button pressed based on the passed in tableView, and event obj
- (NSIndexPath *) indexPathForButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView 
{
    // get all the touches currently being received
    NSSet *touches = [event allTouches];
    
    NSIndexPath *indexPath;
    // as this is a set, check to see if we only have one touch then handle it
    if ([touches count] < 2) {
        UITouch *touch = [touches anyObject];
        // find it's location in the tableView
        CGPoint currentTouchPosition = [touch locationInView:tableView];
        indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
    } else {
        // so we have more than one touch, just find the first touch that maps to one of our rows in the tableView
        for (UITouch *aTouch in touches) {
            CGPoint currentTouchPosition = [aTouch locationInView:tableView];
            
            // should return nil when does not map to a valid indexPath
            indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
            
            // we found a valid one, to return that
            if (indexPath != nil) {
                break;
            }
        }
    }
    
    return indexPath;
}

// create the dialing viewController, this is totally different operation then the contacts selection so we have a flip transition to show that.
- (void)connectWithContact:(NSDictionary *)callInfo  delegate:(id<DialingViewDelegate>)delegate
{
    DialingViewController *dialing = [[DialingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dialing];
    
    NSLog(@"callInfo: %@", callInfo);
    // flip transition, to show we are going into a new phase
    dialing.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    dialing.delegate = delegate;
    
    // set the callig info
    [dialing.dialingDS setPhoneInfo:callInfo];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    [nav release];
    
}

#pragma mark - DialingViewDelegate

// guess this could be handled via popViewController by the loginViewController..
- (void) callRequestSent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// guess this could be handled via popViewController by the loginViewController..
- (void) callRequestCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end








