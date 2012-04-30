//
//  LoginInfoViewDataSource.h
//  Dialer
//
//  Created by William Richardson on 4/30/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfoViewDataSource : NSObject <UITableViewDataSource>
{
    UITableView *_tableView;
}

@property (nonatomic, retain) UITableView *tableView;

- (NSString *)titleForSection:(NSInteger)section;

- (id) secAttrForSection:(NSInteger)section;
   
@end















//