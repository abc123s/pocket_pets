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

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (assign, nonatomic) dispatch_group_t locationGroup;
@property (assign, nonatomic) dispatch_group_t geocoderGroup;
@property (assign, nonatomic) dispatch_group_t waterGroup;

@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSMutableString *currentText;
@property (assign, nonatomic) dispatch_group_t airGroup;

@property (assign, nonatomic) float elevation;
@property (assign, nonatomic) BOOL inWater;
@property (strong, nonatomic) NSDate *attackTimer;
@property (strong, nonatomic) Battle *battle;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) Pet *opponent;
@property (weak, nonatomic) BattleState *state;

- (void)show:(BOOL)new;  // update screen info
- (void)prog; // update second progress bar
- (void)end:(NSString *)message; // alert view on endgame

@end

@implementation BattleViewController

// Location Variables
@synthesize locationManager = _locationManager;
@synthesize locationGroup = _locationGroup;
@synthesize geocoderGroup = _geocoderGroup;
@synthesize waterGroup = _waterGroup;
@synthesize geocoder = _geocoder;

// XML Parsing Variables
@synthesize currentElement = _currentElement;
@synthesize currentText = _currentText;
@synthesize airGroup = _airGroup;

// Battle Variables
@synthesize elevation = _elevation;
@synthesize inWater = _inWater;
@synthesize state = _state;
@synthesize attackTimer = _attackTimer;
@synthesize battle = _battle;
@synthesize pet = _pet;
@synthesize opponent = _opponent;

// UI Variables
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

        self.attackTimer = [NSDate date]; // Initialize attack time record

        NSLog(@"%@ defaults = %@", [self class], 
              [[NSUserDefaults standardUserDefaults] 
               persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]);
        
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
        // Create the geocoder if this object does not already have one.
        if (self.geocoder == nil)
        {
            self.geocoder = [[CLGeocoder alloc] init];
        }
        
        self.locationGroup = dispatch_group_create();
        dispatch_group_enter(self.locationGroup);
        
        [self.locationManager startUpdatingLocation];
           
        // wait until we get a satisfactory opponent back; make sure 
        // main loop is still running.
        while (dispatch_group_wait(self.locationGroup, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
        }
        dispatch_release(self.locationGroup);
        
        // Turn off location manager.
        [self.locationManager stopUpdatingLocation];
        
        // Initialize battle
        self.battle = [[Battle alloc] initWithPet1:self.pet andPet2:self.opponent];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self show:YES];
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

// Helper function to bundle all UI updates
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
        [self performSelector:@selector(end:)
                   withObject:@"Defeat."
                   afterDelay:2.0];
    }
}

// Helper function for delayed display of battle information
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

// Attack button
- (IBAction)attack:(id)sender
{
    NSTimeInterval howRecent = [self.attackTimer timeIntervalSinceNow];

    // delay ability to attack 
    if (abs(howRecent) > 0.5)
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
        [UserPets savePet:self.pet];
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
        
        self.geocoderGroup = dispatch_group_create();
        dispatch_group_enter(self.geocoderGroup);
        
        // Determine correct pokemon type.
        [self locationType:newLocation];
        
        // wait until we get a satisfactory opponent back; make sure 
        // main loop is still running.
        while (dispatch_group_wait(self.geocoderGroup, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
        }
        dispatch_release(self.geocoderGroup);

        //finished determining opponent, unblock.
        dispatch_group_leave(self.locationGroup);

    }
}

// If location determination failed, just pick a random pokemon.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Generate random opponent
    self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                             andType:nil];
    
    dispatch_group_leave(self.locationGroup);
    
}

#pragma mark - Geocoder stuff.

- (void)locationType:(CLLocation *)location
{
    // get elevation data from google for current gps location
    NSString *url = 
    [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/elevation/xml?locations=%f,%f&sensor=true",
     location.coordinate.latitude, location.coordinate.longitude];
    
    // parse xml
    NSXMLParser *parser = [[NSXMLParser alloc] 
                           initWithContentsOfURL:[NSURL URLWithString:url]];
    [parser setDelegate: self];
    
    self.airGroup = dispatch_group_create();
    dispatch_group_enter(self.airGroup);
    
    [parser parse];
    
    // wait until we get an altitude back.
    while (dispatch_group_wait(self.airGroup, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    }
    
    dispatch_release(self.airGroup);
     
    NSLog([NSString stringWithFormat:@"%f", location.altitude]);
    NSLog([NSString stringWithFormat:@"%f", self.elevation]);
    
    if (self.elevation > (location.altitude + 10)) 
    {
        self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                 andType:@"Air"];
        // finished determining opponent, unblock.    
        dispatch_group_leave(self.geocoderGroup);

    }
    else 
    {
        // check locations near current location to see if near water.
        CLLocation *location1 = [[CLLocation alloc] 
                                 initWithLatitude:location.coordinate.latitude
                                 longitude:location.coordinate.longitude + .0002];
        CLLocation *location2 = [[CLLocation alloc] 
                                 initWithLatitude:location.coordinate.latitude
                                 longitude: location.coordinate.longitude - .0002];
        CLLocation *location3 = [[CLLocation alloc] 
                                 initWithLatitude:location.coordinate.latitude + .0002
                                 longitude:location.coordinate.longitude];
        CLLocation *location4 = [[CLLocation alloc] 
                                 initWithLatitude:location.coordinate.latitude -.0002
                                 longitude:location.coordinate.longitude];
    
        self.waterGroup = dispatch_group_create();
    
        // check nearby locations for water
        [self checkInWater:location1];
        [self checkInWater:location2];    
        [self checkInWater:location3];   
        [self checkInWater:location4];
    
        dispatch_release(self.waterGroup);
    
        [self.geocoder 
         reverseGeocodeLocation: self.locationManager.location
         completionHandler:^(NSArray *placemarks, NSError *error) 
         {
             if (error == nil) 
             {
                 CLPlacemark *curPlacemark = [placemarks objectAtIndex:0];
                 if (curPlacemark.inlandWater != nil || 
                     curPlacemark.ocean != nil ||
                     self.inWater == YES)
                 {
                     self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                              andType:@"Water"];
                 }
                 else 
                 {
                     self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                          andType:@"Ground"];
                 }
             }
             else 
             {
                 // Generate random opponent.
                 self.opponent = [[Pet alloc] initRandomWithLevel:self.pet.level 
                                                      andType:nil];
            
             }
         
             // finished determining opponent, unblock.
             dispatch_group_leave(self.geocoderGroup);
         
         }];
    }
}

/* 
 * A function that checks if a location is a body of water.
 * Apple doesn't seem to let you make multiple reverseGeocodeLocation requests
 * at the same time; if it detects that these requests are being made 
 * concurrently, it seems to deny all requests. Accordingly, we use
 * dispatch_groups here to guarantee that all these requests are being made
 * sequentially. 
 */

- (void)checkInWater:(CLLocation *)location
{
    dispatch_group_enter(self.waterGroup);

    CLGeocoder *geocoder = [[CLGeocoder alloc] init]; 
    [geocoder
     reverseGeocodeLocation:location 
     completionHandler:^(NSArray *placemarks, NSError *error) 
     {
         CLPlacemark *curPlacemark = [placemarks objectAtIndex:0];
         if (curPlacemark.inlandWater != nil || curPlacemark.ocean != nil)
         {
             self.inWater = YES;
         }
         dispatch_group_leave(self.waterGroup);
     }];
    
    while (dispatch_group_wait(self.waterGroup, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    }

}

#pragma mark - NSXMLParser stuff.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = [NSString stringWithString:elementName];
    if ([elementName isEqualToString:@"elevation"]) {
        self.currentText = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.currentElement isEqualToString:@"elevation"]) {
        [self.currentText appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"elevation"]) 
    {
        
        self.elevation = [self.currentText floatValue];
        dispatch_group_leave(self.airGroup);
    }
}


@end
