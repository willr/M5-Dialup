//
//  IndividualContainer.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "PersonContainer.h"
#import "ToggleImageControl.h"
#import "Constants.h"

@implementation PersonContainer

@synthesize person = _person, favoritesListDelegate = _favoritesListDelegate;

- (NSString *)name
{
    return [self.person objectForKey:PersonName];
}

- (NSDictionary *)getNameAndPhoneNumFor:(NSIndexPath *)indexPath
{
    NSMutableDictionary *phoneEntry = [self getPhoneEntryFor:indexPath];
    NSString *phoneTxt = [phoneEntry objectForKey:PersonPhoneNumber];
    
    NSDictionary *copy = [[[NSDictionary alloc] initWithObjectsAndKeys:
                           [self name], PersonName, 
                           phoneTxt, PersonPhoneNumber, 
                           nil] autorelease];
    
    return copy;
}

- (NSMutableDictionary *)getPhoneEntryFor:(NSIndexPath *)indexPath
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    NSMutableDictionary *phoneEntry = [[phoneList allValues] objectAtIndex:indexPath.section];
    
    return phoneEntry;
}

#pragma mark - ToggleDelegate

- (void)toggled:(id)sender
{
    ToggleImageControl *toggler = (ToggleImageControl *)sender;
    int section = toggler.tag;
    
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    NSArray *phoneEntries = [phoneList allValues];
    NSMutableDictionary *phoneEntry = [phoneEntries objectAtIndex:section];
    NSNumber *phoneId = [phoneEntry valueForKey:PersonPhoneId];
    NSNumber *isFavorite = [phoneEntry valueForKey:PersonIsFavorite];
    
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
    return [[self.person objectForKey:PersonPhoneList] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *GeneralCellIdentifier = DetailListTableViewCellId;
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GeneralCellIdentifier];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GeneralCellIdentifier] autorelease];
    }
    
    // set the data for the cell
    CGRect textFrame = CGRectMake(45.0, 3.0, 240.0, 40.0);
    NSDictionary *namePhone = [self getNameAndPhoneNumFor:indexPath];
	// cell.textLabel.text = [[phoneList allValues] objectAtIndex:indexPath.section];
    UILabel *txtView = [[UILabel alloc] initWithFrame:textFrame];
    txtView.text = [namePhone objectForKey:PersonPhoneNumber];
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
    NSMutableDictionary *phoneEntry = [self getPhoneEntryFor:indexPath];
    NSNumber *phoneId = [phoneEntry objectForKey:PersonPhoneId];
    BOOL isFavorite = [self.favoritesListDelegate isFavorite:phoneId];
    if (isFavorite) {
        toggleControl.activated = false;
        [toggleControl toggleImage];
        [phoneEntry setObject:[NSNumber numberWithBool:YES] forKey:PersonIsFavorite];
    }
    toggleControl.activated = true;
    
    [toggleControl release];
    // [callButton release];  // call button is autoreleased
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *phoneList = [self.person objectForKey:PersonPhoneList];
    
    return [self getPhoneLabelForDisplay:[[phoneList allKeys] objectAtIndex:section]];
}

@end
