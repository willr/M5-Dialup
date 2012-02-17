//
//  IndividualContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "PersonContainer.h"
#import "ToggleImageControl.h"

@implementation PersonContainer

@synthesize person = _person;

- (NSString *)name
{
    return [self.person objectForKey:@"name"];
}

#pragma mark - TableViewDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return the number of sections
    return [[self.person objectForKey:@"phoneList"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *GeneralCellIdentifier = @"GeneralCell";
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GeneralCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GeneralCellIdentifier];
    }
    
    // set the data for the cell
    CGRect textFrame = CGRectMake(45.0, 3.0, 240.0, 40.0);
    NSDictionary *phoneList = [self.person objectForKey:@"phoneList"];
    NSString *phoneTxt = [[phoneList allValues] objectAtIndex:indexPath.section];
	// cell.textLabel.text = [[phoneList allValues] objectAtIndex:indexPath.section];
    UILabel *txtView = [[UILabel alloc] initWithFrame:textFrame];
    txtView.text = phoneTxt;
    txtView.font = [UIFont boldSystemFontOfSize:19];

    [cell.contentView addSubview:txtView];
    [txtView release];
    
    
    UIButton *callButton;
    // UIButton *favButton;
    callButton = [self createCallButton];
    // favButton = [self createFavoriteButton];

    cell.accessoryView = callButton;
    
    CGRect frame = CGRectMake(5.0, 0.0, 35.0, 35.0);
    ToggleImageControl *toggleControl = [[ToggleImageControl alloc] initWithFrame: frame];
    toggleControl.tag = indexPath.row;  // for reference in notifications.
    [cell.contentView addSubview: toggleControl];
    [toggleControl release];
    
    [callButton release];
    // [favButton release];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *phoneList = [self.person objectForKey:@"phoneList"];
    
    return [self getPhoneLabelForDisplay:[[phoneList allKeys] objectAtIndex:section]];
}

@end
