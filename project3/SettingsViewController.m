//
//  SettingsViewController.m
//  project3
//
//  Created by Will Sun on 5/3/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize delegate = _delegate;
@synthesize textField = _textField;

- (id)initWithNibName:(NSString *)nibNameOrNil 
           controller:(id)controller
               bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.delegate = controller;
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

// Called once finished
- (IBAction)done:(id)sender
{
    // hide keyboard
    [self.textField resignFirstResponder];
    
    // save altitude
    [User setAlt:[self.textField.text floatValue]];
    
    // give up control
    [self.delegate settingsViewControllerDidFinish:self];
}
@end
