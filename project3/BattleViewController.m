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

@interface BattleViewController ()

@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) Pet *opponent;
@property (strong, nonatomic) Battle *battle;
@property (weak, nonatomic) BattleState *state;

// update screen info
- (void)show;

@end

@implementation BattleViewController

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Generate opponent, currently hardcoded
        self.opponent = [[Pet alloc] initWithName:@"Pikachu" 
                                         andLevel:1 
                                           andExp:0 
                                       andActions:[NSArray arrayWithObject:@"Tackle"]];        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self show];
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
    // Take in pet
    self.pet = [self.delegate passPet];
    
    // Initialize battle
    self.battle = [[Battle alloc] initWithPet1:self.delegate.passPet andPet2:self.opponent];
    
    
    self.proPetName.text = self.pet.name;
    self.oppPetName.text = self.opponent.name;
    self.proPetPic.image = [UIImage imageNamed:self.pet.battlePath];
    self.oppPetPic.image = [UIImage imageNamed:self.opponent.oppPath];    
    
    // register the attack on the opponent
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



@end
