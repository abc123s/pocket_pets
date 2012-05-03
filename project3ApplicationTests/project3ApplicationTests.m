//
//  project3ApplicationTests.m
//  project3ApplicationTests
//
//  Created by Will Sun on 5/3/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "project3ApplicationTests.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "PetViewController.h"
#import "BattleViewController.h"
#import "SingleViewController.h"
#import "User.h"

@interface project3ApplicationTests ()

@property (nonatomic, readwrite, weak) AppDelegate *appDelegate;
@property (nonatomic, readwrite, weak) UITabBarController *tabController;
@property (nonatomic, readwrite, weak) UIView *view;

@property (nonatomic, readwrite, weak) PetViewController *petController;
@property (nonatomic, readwrite, weak) BattleViewController *battleController;

@end


@implementation project3ApplicationTests

@synthesize appDelegate=_appDelegate;
@synthesize tabController=_tabController;
@synthesize view=_view;

@synthesize petController = _petController;
@synthesize battleController = _battleController;

- (void)setUp
{
    [super setUp];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.tabController = self.appDelegate.tabBarController;
    self.view = self.tabController.view;
    
    // set up NSUserDefaults for tests
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSDictionary alloc] init] forKey:@"pets"];
    [defaults synchronize];
    [User initNewWithName:@""];
    
    self.petController = [self.tabController.viewControllers objectAtIndex:0];
    self.battleController = [[BattleViewController alloc]initWithNibName:@"BattleViewController"
                                                              controller:self.petController
                                                                  bundle:nil];
}

- (void)testAppDelegate
{
    STAssertNotNil(self.appDelegate, @"Cannot find the application delegate");
}

- (void)testPetView
{
    SingleViewController *singleController = [self.petController.viewControllers objectAtIndex:0];
    // STAssertEqualObjects(singleController.name, @"Pikachu", @"Name error");
}

@end
