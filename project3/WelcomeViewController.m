//
//  WelcomeViewController.m
//  project3
//
//  Created by Will Sun on 4/24/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UserPets.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize continueGame = _continueGame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide continue game button if nothing to continue
    if ([UserPets noPets])
        self.continueGame.hidden = YES;
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 0:
        {
            [UserPets initNewWithName:@"Pikachu"];
            break;
        }
        case 1:
        {
            [UserPets initNewWithName:@"Charmander"];
            break;
        }
        case 2:
        {
            [UserPets initNewWithName:@"Bulbasaur"];
            break;
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)newGame
{
    // show alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose Pet"
                                                    message:nil 
                                                   delegate:self
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"Pikachu", @"Charmander", @"Bulbasaur", nil];

    [alert show];
}

- (IBAction)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
