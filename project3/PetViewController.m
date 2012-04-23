//
//  PetViewController.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "PetViewController.h"

@interface PetViewController ()

@end

@implementation PetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Pets", @"Pets");
        self.tabBarItem.image = [UIImage imageNamed:@"23-bird"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end