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

@synthesize person = _person, favoritesListDelegate = _favoritesListDelegate;

- (NSString *)name
{
    return [self.person objectForKey:@"name"];
}

#pragma mark - ToggleDelegate

- (void)toggled:(id)sender
{
    ToggleImageControl *toggler = (ToggleImageControl *)sender;
    int section = toggler.tag;
    
    NSDictionary *phoneList = [self.person objectForKey:@"phoneList"];
    NSArray *phoneEntries = [phoneList allValues];
    NSMutableDictionary *phoneEntry = [phoneEntries objectAtIndex:section];
    NSNumber *phoneId = [phoneEntry valueForKey:@"phoneId"];
    NSNumber *isFavorite = [phoneEntry valueForKey:@"isFavorite"];
    
    // determine current state of the phoneNumber
    if ([isFavorite boolValue]) {
        [self.favoritesListDelegate removeFavorite:phoneId];
    } else {
        [self.favoritesListDelegate addFavorite:self.person];
    }
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GeneralCellIdentifier] autorelease];
    }
    
    // set the data for the cell
    CGRect textFrame = CGRectMake(45.0, 3.0, 240.0, 40.0);
    NSDictionary *phoneList = [self.person objectForKey:@"phoneList"];
    NSMutableDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:indexPath.section];
    NSString *phoneTxt = [phoneEntry objectForKey:@"phoneNumber"];
	// cell.textLabel.text = [[phoneList allValues] objectAtIndex:indexPath.section];
    UILabel *txtView = [[UILabel alloc] initWithFrame:textFrame];
    txtView.text = phoneTxt;
    txtView.font = [UIFont boldSystemFontOfSize:19];

    [cell.contentView addSubview:txtView];
    [txtView release];
    
    UIButton *callButton;
    callButton = [self configureCallButton];

    cell.accessoryView = callButton;
    
    CGRect frame = CGRectMake(5.0, 0.0, 35.0, 35.0);
    ToggleImageControl *toggleControl = [[ToggleImageControl alloc] initWithFrame: frame];
    [cell.contentView addSubview: toggleControl];
    toggleControl.tag = indexPath.section;  // for reference in notifications.
    toggleControl.toggleDelegate = self;
    
    // determine if number is a favorite or not.
    // if so toggle
    NSNumber *phoneId = [phoneEntry objectForKey:@"phoneId"];
    BOOL isFavorite = [self.favoritesListDelegate isFavorite:phoneId];
    if (isFavorite) {
        toggleControl.activated = false;
        [toggleControl toggleImage];
        [phoneEntry setObject:[NSNumber numberWithBool:YES] forKey:@"isFavorite"];
    }
    toggleControl.activated = true;
    
    [toggleControl release];
    // [callButton release];  // call button is autoreleased
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *phoneList = [self.person objectForKey:@"phoneList"];
    
    return [self getPhoneLabelForDisplay:[[phoneList allKeys] objectAtIndex:section]];
}

@end
