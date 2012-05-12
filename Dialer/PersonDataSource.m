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

- (void) dealloc
{
    self.person = nil;
    self.favorites = nil;
    
    [super dealloc];
}

// allows the viewController to see when the favorites have been modified and reload the tableview
- (BOOL) favoritesModified
{
    return self.favorites.favoritesModified;
}

// common method to retrieve the name and phoneEntry info for actually placing a call with the system
- (NSDictionary *)nameAndPhoneNumberAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.person nameAndPhoneNumberAtIndex:indexPath.section];
}

#pragma mark - TableViewDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return the number of sections, one section for each phone entry the user has
    return [self.person count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // the section headers will be used for phoneType
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // tag must be negative, as toggleControl tag is equal to indexPath.Section
    static NSInteger callButtonTag = -9;
    static NSInteger phoneNumberTag = -10;
    
    // get the next cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailListTableViewCellId];
    if (cell == nil) {
		// Common to all cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailListTableViewCellId] autorelease];
        
        // add the call button, so we can call directly from this screen
        UIButton *callButton;
        callButton = [self configureCallButton:self.callButtonDelegate];
        callButton.tag = callButtonTag;
        cell.accessoryView = callButton;
        
        // create the label to hold the phone number being displayed
        CGRect textFrame = CGRectMake(45.0, 3.0, 240.0, 40.0);
        UILabel *txtView = [[UILabel alloc] initWithFrame:textFrame];
        txtView.font = [UIFont boldSystemFontOfSize:19];
        // to be able to find it later, to set the value
        txtView.tag = phoneNumberTag;
        [cell.contentView addSubview:txtView];
        [txtView release];
        
        // favorite state toggle with image showing current favorite status
        //  selecting image, on/off favorite status
        CGRect frame = CGRectMake(5.0, 0.0, 35.0, 35.0);
        ToggleImageControl *toggleControl = [[ToggleImageControl alloc] initWithFrame: frame];
        [cell.contentView addSubview: toggleControl];
        toggleControl.tag = indexPath.section;  // for reference in notifications.
        toggleControl.toggleDelegate = self;    
        
        [toggleControl release];
    }
    
    // phone number for the favorite in index specified by sections
    // set the data for the cell, phone number as the cell contents, section header as the phoneTypes
    UILabel *txtView = (UILabel *)[cell.contentView viewWithTag:phoneNumberTag];
    NSDictionary *namePhone = [self.person nameAndPhoneNumberAtIndex:indexPath.section] ;
    txtView.text = [namePhone objectForKey:PersonPhoneNumber];
    
    // find the toggleImageControl underneath the subview
    NSArray *subViews = cell.contentView.subviews;
    /*
    NSLog(@"subViews: %@, indexPath: %@", subViews, indexPath);
    NSLog(@"tags: (0):%d  (1):%d", ((UIControl *)[subViews objectAtIndex:0]).tag, ((UIControl *)[subViews objectAtIndex:1]).tag);
     */
    // iterate through the subViews, there should only be 2...
    ToggleImageControl *toggleControl = nil;
    for (UIView *subView in subViews) {
        if (subView.tag == indexPath.section) {
            toggleControl = (ToggleImageControl *)subView;
        }
    }
    
    // determine if number is a favorite or not.
    // if so toggle
    NSNumber *phoneId = [self.person phoneIdAtIndex:indexPath.section];
    BOOL isFavorite = [self.favorites isFavorite:phoneId];
    if (isFavorite) {
        // tell toggleControl to not fire delegate, as we are still setting up control
        toggleControl.activated = false;
        [toggleControl toggleImage];
    }
    
    // enable control to respond to all button presses
    toggleControl.activated = true;
          
    return cell;
}

// the phone type of the phone entry, section headers display the phone type, phone number in 1 row section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.person phoneTypeAtIndex:section];
}

#pragma mark - ToggleDelegate
// receiver for favorite toggled events
- (void)toggled:(id)sender
{
    // get section number of image toggled
    ToggleImageControl *toggler = (ToggleImageControl *)sender;
    int section = toggler.tag;
    
    // get phoneId and favorite status based on section number
    NSNumber *phoneId = [self.person phoneIdAtIndex:section];
    BOOL isFavorite = [self.favorites isFavorite:phoneId];
    
    // determine current state of the phoneNumber
    if (isFavorite) {
        // if currently favorite then un-favorite
        [self.favorites removeFavorite:phoneId];
    } else {
        // if not currently favorite then add to favoritesContainer
        [self.favorites addFavorite:self.person.person phoneId:phoneId];
    }
}

@end
