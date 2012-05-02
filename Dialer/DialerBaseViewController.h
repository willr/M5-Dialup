//
//  DialerBaseViewController.h
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DialingViewController.h"

// base ViewController to house some common methods that need to be shared
//
@interface DialerBaseViewController : UIViewController<DialingViewDelegate>

- (NSIndexPath *) indexPathForButtonTapped:(id)sender event:(id)event tableView:(UITableView *)tableView ;

- (void)connectWithContact:(NSDictionary *)callInfo delegate:(id<DialingViewDelegate>)delegate;

@end
