//
//  SingleViewController.m
//  project3
//
//  Created by Will Sun on 4/24/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "SingleViewController.h"
#import "BattleViewController.h"
#import "UserPets.h"
#import "PetViewController.h"

@interface SingleViewController ()

@end

@implementation SingleViewController

@synthesize pageNumber = _pageNumber;

@synthesize name = _name;
@synthesize level = _level;
@synthesize atk = _atk;
@synthesize def = _def;
@synthesize spd = _spd;
@synthesize spc = _spc;
@synthesize exp = _exp;
@synthesize hp = _hp;
@synthesize petImage = _petImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

// load the view nib and initialize pageNumber
- (id)initWithPageNumber:(int)page
{
    if (self = [super initWithNibName:@"SingleViewController" bundle:nil])
    {
        self.pageNumber = page;
    }
    return self;
}

- (IBAction)battle:(id)sender
{
    BattleViewController *controller = [[BattleViewController alloc] 
                                          initWithNibName:@"BattleViewController" 
                                          bundle:nil];
    controller.delegate = self;
    
    // [self presentModalViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:NULL];

}

#pragma mark - BattleViewControllerDelegate

- (void)battleViewControllerDidFinish:(BattleViewController *)controller
{
    // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (Pet *)passPet
{
    return [UserPets findPetWithName: self.name.text];
}




@end
