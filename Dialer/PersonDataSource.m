//
//  PersonViewControllerDataSource.m
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "PersonDataSource.h"
#import "ToggleImageControl.h"
#import "Constants.h"

@implementation PersonDataSource

@synthesize person = _person;
@synthesize favorites = _favorites;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        
    }
    return self;
}

- (BOOL) favoritesModified
{
    return self.favorites.favoritesModified;
}

#pragma mark - CallButtonDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // NSDictionary *person = self.person.person;
    /*
     NSString *contactName = [person objectForKey:PersonName];
     NSString *phoneNumber = [person objectForKey:PersonPhoneNumber];
     
     [self.dialerDelegate connectWithContact:contactName phoneNumber:phoneNumber];
     
     */
}

#pragma mark - TableViewDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return the number of sections
    return [self.person count];
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
    NSDictionary *namePhone = [self.person nameAndPhoneNumberAtIndex:indexPath.section];
    
    UILabel *txtView = [[UILabel alloc] initWithFrame:textFrame];
    txtView.text = [namePhone objectForKey:PersonPhoneNumber];
    txtView.font = [UIFont boldSystemFontOfSize:19];
    
    [cell.contentView addSubview:txtView];
    [txtView release];
    
    UIButton *callButton;
    callButton = [self configureCallButton:self.callButtonDelegate];
    
    cell.accessoryView = callButton;
    
    CGRect frame = CGRectMake(5.0, 0.0, 35.0, 35.0);
    ToggleImageControl *toggleControl = [[ToggleImageControl alloc] initWithFrame: frame];
    [cell.contentView addSubview: toggleControl];
    toggleControl.tag = indexPath.section;  // for reference in notifications.
    toggleControl.toggleDelegate = self;
    
    // determine if number is a favorite or not.
    // if so toggle
    NSNumber *phoneId = [self.person phoneIdAtIndex:indexPath.section];
    BOOL isFavorite = [self.favorites isFavorite:phoneId];
    if (isFavorite) {
        toggleControl.activated = false;
        [toggleControl toggleImage];
        // [self.favorites addFavorite:phoneId];
    }
    
    toggleControl.activated = true;
    
    [toggleControl release];
    // [callButton release];  // call button is autoreleased
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.person phoneTypeAtIndex:section];
}

#pragma mark - ToggleDelegate

- (void)toggled:(id)sender
{
    ToggleImageControl *toggler = (ToggleImageControl *)sender;
    int section = toggler.tag;
    
    NSNumber *phoneId = [self.person phoneIdAtIndex:section];
    BOOL isFavorite = [self.favorites isFavorite:phoneId];
    
    // determine current state of the phoneNumber
    if (isFavorite) {
        [self.favorites removeFavorite:phoneId];
    } else {
        [self.favorites addFavorite:self.person.person phoneId:phoneId];
    }
}

@end
