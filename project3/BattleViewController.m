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

// update screen info
- (void)show;

@end

@implementation BattleViewController

@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize battle = _battle;
@synthesize state = _state;
@synthesize pet = _pet;
@synthesize opponent = _opponent;

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

- (void)show
{
    // first attack
    self.proPetName.text = self.pet.name;
    self.oppPetName.text = self.opponent.name;
    self.proPetPic.image = [UIImage imageNamed:self.pet.battlePath];
    self.oppPetPic.image = [UIImage imageNamed:self.opponent.oppPath];    
    
    // register the attack on the opponent
    NSLog(self.state.attack1Message);
    NSLog(self.state.attack2Message);
    self.msg.text = self.state.attack1Message;
    self.oppPetHP.text = [NSString stringWithFormat:@"%d/%d", self.opponent.hp, self.opponent.full];
    self.oppPetBar.progress = (float)self.opponent.hp / (float)self.opponent.full;

    // check if end
    if (self.opponent.hp <= 0)
    {
        [self end:@"Victorious!"];
    }

    // register the attack on user
    self.msg.text = self.state.attack2Message;
    self.proPetHP.text = [NSString stringWithFormat:@"%d/%d", self.pet.hp, self.pet.full];
    self.proPetBar.progress = (float)self.pet.hp / (float)self.pet.full;

    // check if end
    if (self.pet.hp <= 0)
    {
        [self end:@"Defeat."];
    }
}

- (IBAction)attack:(id)sender
{
    // Make an attack    
    self.state = [self.battle doAction1:[self.pet.actions objectAtIndex:0]  
                             andAction2:[self.opponent.actions objectAtIndex:0]];
    
    // Show results
    [self show];
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
        
        // Determine correct pokemon type.
        [self.geocoder 
         reverseGeocodeLocation: self.locationManager.location
         completionHandler:^(NSArray *placemarks, NSError *error) 
         {
             if (error != nil) 
             {
                 // Generate opponent, currently hardcoded
                 self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                          andType:nil];
                 
                 // Initialize battle
                 self.battle = [[Battle alloc] initWithPet1:self.pet andPet2:self.opponent];
                 
                 // Turn off location manager.
                 [self.locationManager stopUpdatingLocation];
                 
                 [self show];
             }
             else 
             {
                 CLPlacemark *curPlacemark = [placemarks objectAtIndex:0];
                 if (curPlacemark.inlandWater != nil || curPlacemark.ocean != nil)
                 {
                     self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                              andType:@"Water"];
                 }
                 else if (false) //elevation stuff to be added later
                 {
                     self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                              andType:@"Air"];
                 }
                 else 
                 {
                     self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                              andType:@"Ground"];
                 }
                 
                 // Initialize battle
                 self.battle = [[Battle alloc] initWithPet1:self.pet 
                                                    andPet2:self.opponent];
                 
                 // Update UI
                 [self show];
             }
         }];

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
    
    [self show];
}

@end
