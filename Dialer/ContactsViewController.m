//
//  ContactsViewController.m
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ContactsViewController.h"
#import "PersonViewController.h"
#import "Constants.h"

@implementation ContactsViewController

@synthesize addresses = _addresses, tableView = _tableView, dialerDelegate = _dialerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

#pragma mark - CallButtonDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *person = [self.addresses getPersonForPath:indexPath];
    
    NSString *contactName = [person objectForKey:PersonName];
    NSString *phoneNumber = [person objectForKey:PersonPhoneNumber];
    
    [self.dialerDelegate connectWithContact:contactName phoneNumber:phoneNumber];
    
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    // UIButton *button = (UIButton *)sender;
    // UITableViewCell *cell = (UITableViewCell *)[button superview];
    // NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = InitialWindowTitle;
    
    // Get application frame dimensions (basically screen - status bar)
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    // create the table view to show the Contacts stored on the device.
    UITableView *table = [[UITableView alloc] initWithFrame:appRect style:UITableViewStyleGrouped];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    table.delegate = self;
    
    if (self.addresses == nil) {
        self.addresses = [[[ContactListContainer alloc] init] autorelease];
    }
    
    [self.addresses collectAddressBookInfo];
    table.dataSource = self.addresses;
    self.addresses.delegate = self;
    
    // save the tableView variable, cause we will need it for call button
    self.tableView = table;
    
    // cause the table to load
    [table reloadData];
    
    // set the table as the view
    self.view = table;
    
    // release the tableView as it is now being held as the View
    [table release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.addresses.favoritesModified) {
        [self.tableView reloadData];
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
    
    // NSArray *subViews = [self.navigationController viewControllers];
    // NSLog(@"Num viewControllers: %@", [[self.navigationController viewControllers] count]);
    
    PersonViewController *personController = [[PersonViewController alloc] init];
    
    PersonContainer *person = [[PersonContainer alloc] init];
    person.person = [self.addresses getPersonForPath:indexPath];
    personController.personContainer = person;
    person.delegate = personController;
    person.favoritesListDelegate = self.addresses;
    
    NSLog(@"Name: %@", [person.person objectForKey:PersonName]);
    
    [self.navigationController pushViewController:personController animated:YES];
    
    [personController release];
}

@end
