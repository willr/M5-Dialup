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
#import "TestFlight.h"

@implementation ContactsViewController

@synthesize contacts = _contacts;
@synthesize tableView = _tableView;
@synthesize dialerDelegate = _dialerDelegate;
@synthesize tableDataModified = _tableDataModified;
@synthesize halfLoad = _halfLoad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        // Custom initialization
        
        // add self as an observer for ContactsReloaded and FavoritesReloaded
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadDisplay:)
                                                     name:ContactsReloaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadDisplay:)
                                                     name:FavoritesReloaded
                                                   object:nil];
        
        _halfLoad = false;
    }
    return self;
}

- (void) dealloc
{
    self.contacts = nil;
    self.tableView = nil;
    self.dialerDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // hmm should I do to remove x2
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)reloadDisplay:(NSNotification*)notification
{
    NSLog(@"reloadDisplay:: %@", notification.name);
    
    [self reloadTableView];
}

/*
- (UIBarButtonItem *) feedbackButtonCopy
{
    UIBarButtonItem *feedback = [[UIBarButtonItem alloc] initWithTitle:@"Beta Feedback" 
                                                                      style:UIBarButtonItemStylePlain 
                                                                     target:self 
                                                                    action:@selector(launchFeedback:)]; 

    return feedback;
}
*/
- (void) launchFeedback:(id)source
{
    NSLog(@"Launching Beta Feedback");
    
    [TestFlight openFeedbackView];
}

#pragma mark - View lifecycle

- (void)loadView
{
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // since TestFlight feedback is not showing up, after talking with them, they say it is a capacity issue
    // we wont display it as we dont want to people to think they are providing feedback when I dont see it.
    // self.navigationItem.rightBarButtonItem = [self feedbackButtonCopy];
    
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
    
    // since the view is loaded, tell the datasource to load the contacts
    // this should be an async operation, as we dont want to impact the UI thread, by this processing, which can be intesive
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
    // if the favorites have been modified by the dataSource then reload the table to reflect those changes
    if ([self.contacts favoritesModified] || self.tableDataModified) {
        [self reloadTableView];
    }
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) reloadTableView
{
    /*
    if (self.halfLoad) {
        self.halfLoad = true;
    }
     */
    
    [self.tableView reloadData];
    
    self.tableDataModified = false;
    
    /*
    NSLog(@"releadTableView: Bang!");
    
    NSInteger contactCount = [self.contacts.contacts count];
    NSInteger favoriteCount = [self.contacts.favorites count];
    
    NSLog(@"Contacts:: %d", contactCount);
    NSLog(@"Favorites:: %d", favoriteCount);
     */
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cause the cell to deselect animated, nicely when released
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    // we are creating the viewController, dataSource, and containers externally.
    // this is where we do it.
    
    // this is the person selected by the indexPath, we are going to display in PersonView
    PersonContainer *person = [[PersonContainer alloc] init];
    person.person = [self.contacts personAtIndexPath:indexPath];
    
    // dataSource for the tableView
    PersonDataSource *personDS = [[PersonDataSource alloc] init];
    personDS.person = person;
    // have to include the favorites, as the dataSource is responsible for "favorite/un-favorite" phone numbers
    personDS.favorites = self.contacts.favorites;
    // releas cause it was added to dataSource
    [person release];
    
    // create view and add dataSource
    PersonViewController *personController = [[PersonViewController alloc] init];
    personController.person = personDS;

    // this is assign only, a "weak" reference as we use it to build the button
    personDS.callButtonDelegate = personController;
    
    // release dataSource as it is held by viewController
    [personDS release];
    
    // NSLog(@"Name: %@", [person.person objectForKey:PersonName]);
    
    // bring view to front and release, retained controller
    [self.navigationController pushViewController:personController animated:YES];
    
    [personController release];
}

// this method is really only called from checkButtonTapped, as we have a buttonView on accessoryView
// when there is an accessoryView, this method is not called by UITableView
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // get the name and phone number for the row where the button was pressed
    NSDictionary *personNamePhone = [self.contacts nameAndPhoneNumberAtIndexPath:indexPath];

    // NSString *personName = [personNamePhone objectForKey:PersonName];
    // NSString *phoneNumber = [personNamePhone objectForKey:PersonPhoneNumber];
    // NSLog(@"call Person: %@", personNamePhone);

    
    // call the common method to handle starting the phone call
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