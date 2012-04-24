//
//  Pet.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "Pet.h"
#import "Action.h"

@implementation Pet

@synthesize level = _level;
@synthesize hp = _hp;
@synthesize full = _full;
@synthesize exp = _exp;
@synthesize attack = _attack;
@synthesize defense = _defense;
@synthesize speed = _speed;
@synthesize special = _special;

@synthesize name = _name;
@synthesize type = _type;
@synthesize actions = _actions; 
@synthesize spritePath = _spritePath;
@synthesize spritePath = _battlePath;
@synthesize spritePath = _oppPath;


// initialize pet
- (id)initWithName:(NSString *)name 
          andLevel:(int)level
            andExp:(int)exp
          andActions:(NSArray *)actions 
{
    // load dictionary of base pets
    NSDictionary *pets = [NSMutableArray arrayWithContentsOfFile: 
                          [[NSBundle mainBundle] pathForResource:@"pets" 
                                                          ofType:@"plist"]];
    NSDictionary *mypet = [pets objectForKey:name];
    if (self = [super init])
    {
        self.name = [NSMutableString stringWithString:name];
        self.level = level;
        self.exp = exp;
        self.type = [mypet objectForKey:@"type"];
        self.spritePath = [mypet objectForKey:@"spritepath"];
        self.battlePath = [mypet objectForKey:@"battlepath"];
        self.oppPath = [mypet objectForKey:@"opppath"];
        self.full = [[mypet objectForKey:@"hpbase"] intValue] + 
        [[mypet objectForKey:@"hpmult"] intValue] * level; 
        self.hp = self.full;
        self.attack = [[mypet objectForKey:@"attackbase"] intValue] + 
        [[mypet objectForKey:@"attackmult"] intValue] * level; 
        self.defense = [[mypet objectForKey:@"defensebase"] intValue] + 
        [[pets objectForKey:@"defensemult"] intValue] * level; 
        self.speed = [[mypet objectForKey:@"speedbase"] intValue] + 
        [[mypet objectForKey:@"speedmult"] intValue] * level; 
        self.special = [[mypet objectForKey:@"specialbase"] intValue] + 
        [[mypet objectForKey:@"specialmult"] intValue] * level; 
        self.actions = [NSMutableArray arrayWithCapacity:4];
        for (NSString *action in actions)
        {
            NSNumber *damage = [NSNumber numberWithInt: 
                      [Action lookupMoveDamageWithName:action 
                                             andAttack:self.attack
                                            andDefense:self.defense
                                              andSpeed:self.speed
                                            andSpecial:self.special]];
            NSString *actioncopy = [NSString stringWithString: action];
            NSArray *move = [NSArray arrayWithObjects: actioncopy, damage, nil];
            [self.actions addObject:move]; 
        }
    }
    return self;
}

// Implement later
- (NSArray *)levelUp 
{
    return [NSArray init];
}

//Implement later
- (void)updateActions
{
}

@end
