//
//  BattleViewController.m
//  project3
//
//  Created by Will Sun on 4/24/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "BattleViewController.h"
#import "Pet.h"
#import "UserPets.h"
#import "Battle.h"
#import "BattleState.h"
#import <CoreLocation/CoreLocation.h>


@interface BattleViewController ()

@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) Pet *opponent;
@property (strong, nonatomic) Battle *battle;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) BattleState *state;
@property (strong, nonatomic) NSDate *attackTimer;

- (void)show:(BOOL)new;  // update screen info
- (void)prog; // update second progress bar

@end

@implementation BattleViewController

@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize battle = _battle;
@synthesize state = _state;
@synthesize pet = _pet;
@synthesize opponent = _opponent;
@synthesize attackTimer = _attackTimer;

@synthesize delegate = _delegate;
@synthesize proPetName = _proPetName;
@synthesize oppPetName = _oppPetName;
@synthesize proPetHP = _proPetHP;
@synthesize oppPetHP = _oppPetHP;
@synthesize proPetBar = _proPetBar;
@synthesize oppPetBar = _oppPetBar;
@synthesize proPetPic = _proPetPic;
@synthesize oppPetPic = _oppPetPic;
@synthesize msg = _msg;


- (id)initWithNibName:(NSString *)nibNameOrNil 
           controller:(id)controller
               bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = controller;
        
        // Take in pet
        self.pet = [self.delegate passPet];
        
        // Create the location manager if this object does not
        // already have one.
        if (nil == self.locationManager)
        {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            self.locationManager.distanceFilter = 500;

        }
        //Create the geocoder if this object does not already have one.
        if (self.geocoder == nil)
        {
            self.geocoder = [[CLGeocoder alloc] init];
        }
        
        [self.locationManager startUpdatingLocation];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self show];
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

- (void)show:(BOOL)new
{
    // first attack
    self.proPetName.text = self.pet.name;
    self.oppPetName.text = self.opponent.name;
    self.proPetPic.image = [UIImage imageNamed:self.pet.battlePath];
    self.oppPetPic.image = [UIImage imageNamed:self.opponent.oppPath];    

    // register the attack on the opponent
    self.msg.text = self.state.attack1Message;
    self.oppPetHP.text = [NSString stringWithFormat:@"%d/%d", self.opponent.hp, self.opponent.full];
    [self.oppPetBar setProgress:(float)self.opponent.hp / (float)self.opponent.full animated:YES];
    if ((float)self.opponent.hp / (float)self.opponent.full <= 0.1)
    {
        [self.oppPetBar setProgressTintColor:[UIColor redColor]];
    }
    else
    {
        [self.oppPetBar setProgressTintColor:
                [UIColor colorWithRed:43.0/255.0 green:134.0/255.0 blue: 225.0/255.0 alpha: 1]];
    }
    
    // check if end
    if (self.opponent.hp <= 0)
    {
        [self end:@"Victorious!"];
    }

    // register the attack on user
    [self.msg performSelector:@selector(setText:)
                   withObject:self.state.attack2Message
                   afterDelay:2.0];
    // only delay on attack mode, not on initial display
    if (new)
    {
        [self.proPetBar setProgress:(float)self.pet.hp / (float)self.pet.full animated:YES];
        self.proPetHP.text = [NSString stringWithFormat:@"%d/%d", self.pet.hp, self.pet.full];
    }
    else
    {
        [self performSelector:@selector(prog)
                   withObject:nil
                   afterDelay:2.0];
        [self.proPetHP performSelector:@selector(setText:)
                            withObject:[NSString stringWithFormat:@"%d/%d", self.pet.hp, self.pet.full]
                            afterDelay:2.0];
    }
    

    // check if end
    if (self.pet.hp <= 0)
    {
        [self end:@"Defeat."];
    }
}

- (void)prog
{
    [self.proPetBar setProgress:(float)self.pet.hp / (float)self.pet.full animated:YES];
    if ((float)self.pet.hp / (float)self.pet.full <= 0.1)
    {
        [self.proPetBar setProgressTintColor:[UIColor redColor]];
    }
    else
    {
        [self.proPetBar setProgressTintColor:
         [UIColor colorWithRed:43.0/255.0 green:134.0/255.0 blue: 225.0/255.0 alpha: 1]];
    }
}

- (IBAction)attack:(id)sender
{
    NSTimeInterval howRecent = [self.attackTimer timeIntervalSinceNow];

    // delay ability to attack 
    if (abs(howRecent) > 2.0)
    {
        // Make an attack    
        self.state = [self.battle doAction1:[self.pet.actions objectAtIndex:0]  
                                 andAction2:[self.opponent.actions objectAtIndex:0]];
        
        // Show results
        [self show:NO];
        
        self.attackTimer = [NSDate date];
    }
}

- (void)end:(NSString *)message
{
    // show alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Battle Over"
                                                    message:message                
                                                   delegate:self
                                          cancelButtonTitle:@"Return"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // [UserPets savePet:self.pet];
        [self.delegate battleViewControllerDidFinish:self];
    }
}

#pragma mark - CLLocation delegate functions.

// Once you find a location, stop updating location, and use reverse
// geocoding to figure out what type of pokemon to generate.
- (void)locationManager:(CLLocationManager *)locationManager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0 && newLocation.horizontalAccuracy < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        
        // Turn off location manager.
        [self.locationManager stopUpdatingLocation];
        
        // Initialize attack time record
        self.attackTimer = [NSDate date];
        [self show:YES];
    }
}

// If location determination failed, just pick a random pokemon.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Generate random opponent
    self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                             andType:nil];
    
    // Initialize battle
    self.battle = [[Battle alloc] initWithPet1:self.pet andPet2:self.opponent];
    
    // Turn off location manager.
    [self.locationManager stopUpdatingLocation];
    
    self.attackTimer = [NSDate date];
    [self show:YES];
}

@end
