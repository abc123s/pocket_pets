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
    else
        self.continueGame.hidden = NO;
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
        case 1:
        {
            [UserPets initNewWithName:@"Pikachu"];
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
        case 2:
        {
            [UserPets initNewWithName:@"Charmander"];
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
        case 3:
        {
            [UserPets initNewWithName:@"Bulbasaur"];
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
    }
}

- (IBAction)newGame
{
    // show alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose Pet"
                                                    message:nil 
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"Pikachu", @"Charmander", @"Bulbasaur", nil];

    [alert show];
}

- (IBAction)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
