//
//  IndividualContactViewController.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "PersonViewController.h"

#import "Constants.h"

@implementation PersonViewController

@synthesize person = _person;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    self.person = nil;
    self.tableView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // create the table view to show the Contacts stored on the device.
    UITableView *table = [[UITableView alloc] initWithFrame:appRect style:UITableViewStyleGrouped];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    table.delegate = self;
    self.tableView = table;
    
    table.dataSource = self.person;
    
    // cause the table to load
    [table reloadData];
    
    // set the table as the view
    self.view = table;
    
    // release the tableView as it is now being held as the View
    [table release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the title to be name of the person's information we are showing
    self.title = self.person.person.name;
    
    // cause the table to load
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // if favorites were modified, then persist the favorites as a file for later
    // we do this now, so we dont have to keep track of it
    // this should be an async operation
    if (self.person.favoritesModified) {
        [self.person.favorites saveFavorites];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cause the cell to deselect animated, nicely when released
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

// this method is really only called from checkButtonTapped, as we have a buttonView on accessoryView
// when there is an accessoryView, this method is not called by UITableView
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // get the name and phone number for the row where the button was pressed
    NSDictionary *personNamePhone = [self.person nameAndPhoneNumberAtIndexPath:indexPath];
    
    /*
    NSString *personName = [personNamePhone objectForKey:PersonName];
    NSString *phoneNumber = [personNamePhone objectForKey:PersonPhoneNumber];
    NSLog(@"call Person: %@ at %@", personName, phoneNumber);
    */
    
    [self connectWithContact:personNamePhone delegate:self];
}

#pragma mark - CallButtonDelegate

// this method handles all button Presses for the call button
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForButtonTapped:sender event:event tableView:self.tableView];
    
    [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

@end










//
