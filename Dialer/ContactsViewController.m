//
//  ContactsViewController.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ContactsViewController.h"
#import "DialerBaseViewController.h"
#import "PersonViewController.h"
#import "Constants.h"
#import "AddressBookContainer.h"
#import "PersonDataSource.h"

@implementation ContactsViewController

@synthesize contacts = _contacts;
@synthesize tableView = _tableView;
@synthesize dialerDelegate = _dialerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // create the table view to show the Contacts stored on the device.
    UITableView *table = [[UITableView alloc] initWithFrame:appRect style:UITableViewStyleGrouped];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    table.delegate = self;
    
    if (self.contacts == nil) {
        self.contacts = [[[ContactsDataSource alloc] init] autorelease];
        
        // this is assign only, a "weak" reference as we use it to build the button
        self.contacts.callButtonDelegate = self;
    }
    
    table.dataSource = self.contacts;
    
    // save the tableView variable, cause we will need it for call button
    self.tableView = table;
    
    // cause the table to load
    [table reloadData];
    
    // set the table as the view
    self.view = table;
    
    // release the tableView as it is now being held as the View
    [table release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = InitialWindowTitle;
    
    [self.contacts collectAddressBookInfo];
    
    // cause the table to load
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.contacts favoritesModified]) {
        [self.tableView reloadData];
    }
    
    [super viewWillAppear:animated];
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
        
    PersonContainer *person = [[PersonContainer alloc] init];
    person.person = [self.contacts personAtIndexPath:indexPath];
    
    PersonDataSource *personDS = [[PersonDataSource alloc] init];
    personDS.person = person;
    personDS.favorites = self.contacts.favorites;
    [person release];
    
    PersonViewController *personController = [[PersonViewController alloc] init];
    personController.person = personDS;

    // this is assign only, a "weak" reference as we use it to build the button
    personDS.callButtonDelegate = personController;

    NSLog(@"Name: %@", [person.person objectForKey:PersonName]);
    
    [self.navigationController pushViewController:personController animated:YES];
    
    [personController release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *personNamePhone = [self.contacts nameAndPhoneNumberAtIndexPath:indexPath];
    
    NSString *personName = [personNamePhone objectForKey:PersonName];
    NSString *phoneNumber = [personNamePhone objectForKey:PersonPhoneNumber];
    NSLog(@"call Person: %@ at %@", personName, phoneNumber);
    
    [self connectWithContact:personName phoneNumber:phoneNumber delegate:self];
}

#pragma mark - CallButtonDelegate

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForButtonTapped:sender event:event tableView:self.tableView];
    
    [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

@end










//