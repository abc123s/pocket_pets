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
@synthesize battlePath = _battlePath;
@synthesize oppPath = _oppPath;


// helper function prototypes
NSInteger compareScores(id score1, id score2, void *context);

// initialize pet
- (id)initWithName:(NSString *)name 
          andLevel:(int)level
             andHp:(int)hp
            andExp:(int)exp
          andActions:(NSArray *)actions 
{
    if (self = [super init])
    {
        // load dictionary of base pets
        NSDictionary *pets = [NSDictionary dictionaryWithContentsOfFile: 
                          [[NSBundle mainBundle] pathForResource:@"pets" 
                                                          ofType:@"plist"]];
        NSDictionary *mypet = [pets objectForKey:name];

        self.name = [NSMutableString stringWithString:name];
        self.level = level;
        self.exp = exp;
        self.type = [mypet objectForKey:@"type"];
        self.spritePath = [mypet objectForKey:@"spritepath"];
        self.battlePath = [mypet objectForKey:@"battlepath"];
        self.oppPath = [mypet objectForKey:@"opppath"];
        self.full = [[mypet objectForKey:@"hpbase"] intValue] + 
        [[mypet objectForKey:@"hpmult"] intValue] * level; 
        
        // flag for new pet, with -1
        if (hp < 0)
            self.hp = self.full;
        else
            self.hp = hp;
        
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

- (id)initRandomWithLevel:(int)level andType:(NSString *)type
{
    // load dictionary of base pets
    NSDictionary *pets = [NSDictionary dictionaryWithContentsOfFile: 
                          [[NSBundle mainBundle] pathForResource:@"pets" 
                                                          ofType:@"plist"]];
        
    NSArray *petsOfType = 
    [[pets keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) 
      {
          if (type == nil)
              return YES;
          else 
          {
              return([[obj objectForKey:@"type"] isEqualToString: type]);
          }
      }] allObjects];
    NSLog([NSString stringWithFormat:@"%d", petsOfType.count]);
    NSString *name = [petsOfType objectAtIndex:(arc4random() 
                      % petsOfType.count)];
    int approxLevel = level;
    if (level >= 4)
    {
        approxLevel += (arc4random() % (level/4)) - (level/2);
    }
    
    NSDictionary *mypet = [pets objectForKey:name];
    
    NSDictionary *actionDict = [mypet objectForKey:@"actions"];
    
    NSArray* myActionKeys = 
    [[[actionDict allKeys] filteredArrayUsingPredicate: 
         [NSPredicate predicateWithBlock:
          ^BOOL(id evaluatedObject, NSDictionary *bindings) 
          {
              return ([evaluatedObject intValue] < approxLevel);
          }]] sortedArrayUsingFunction:compareLevels context:nil];
    
    if (myActionKeys.count > 4) 
        myActionKeys = [myActionKeys subarrayWithRange: NSMakeRange(0,4)];
    
    NSArray* myActions = [actionDict objectsForKeys:myActionKeys 
                                     notFoundMarker:@""];
    
    return [self initWithName:name 
                     andLevel:approxLevel
                        andHp:[[mypet objectForKey:@"hpbase"] intValue] + [[mypet objectForKey:@"hpmult"] intValue] * level
                       andExp:0 
                   andActions:myActions];
    
}

// Implement later
- (NSArray *)levelUp 
{    
}

//Implement later
- (void)updateActions
{
}
         
#pragma mark - helper function
/*
 * Helper function to compare scores.
 */
NSInteger compareLevels(id level1, id level2, void *context) 
{
    int v1 = [level2 intValue];
    int v2 = [level1 intValue];
    if (v1 > v2)
        return NSOrderedAscending;
    else if (v1 < v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
@end
