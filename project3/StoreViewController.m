//
//  StoreViewController.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "StoreViewController.h"
#import "Item.h"
#import "User.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

@synthesize store = _store;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // Load in data
        self.store = [NSArray arrayWithArray:[Item store]];
        
        self.title = NSLocalizedString(@"Store", @"Store");
        self.tabBarItem.image = [UIImage imageNamed:@"24-gift"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.store count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *item = [self.store objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"name"];
    NSString *itemType = [item objectForKey:@"type"];
    if ([itemType isEqualToString:@"catch"])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Catch: %f mult", 
                                     [[item objectForKey:itemType] floatValue]];
    }
    else if ([itemType isEqualToString:@"heal"])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Heal: %d hp",
                                     [[item objectForKey:itemType] intValue]];
    }
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [customButton addTarget:self action:@selector(purchase:) forControlEvents: UIControlEventTouchUpInside];
    [customButton setTag:9001]; // to ensure correct button
    [cell addSubview:customButton];
    [cell setIndentationWidth:45];
    [cell setIndentationLevel:1];
    
    return cell;
}

// To be called on button press
- (void)purchase:(UIButton *)sender
{
    // Double-check correct button
    if (sender.tag == 9001)
    {
        UITableViewCell *cell = ((UITableViewCell *)[sender superview]);
        NSString *item = [[self.store objectAtIndex:[self.tableView indexPathForCell:cell].row] objectForKey:@"name"];
        [User addItem:item];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
