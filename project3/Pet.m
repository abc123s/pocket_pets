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
@synthesize petData = _petData;


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
        if (self.petData == nil)
        {
            // load dictionary of base pets
            NSDictionary *pets = [NSDictionary dictionaryWithContentsOfFile: 
                                  [[NSBundle mainBundle] pathForResource:@"pets" 
                                                                  ofType:@"plist"]];
            self.petData = [pets objectForKey:name];
        }
        self.name = [NSMutableString stringWithString:name];
        self.level = level;
        self.exp = exp;
        self.type = [self.petData objectForKey:@"type"];
        self.spritePath = [self.petData objectForKey:@"spritepath"];
        self.battlePath = [self.petData objectForKey:@"battlepath"];
        self.oppPath = [self.petData objectForKey:@"opppath"];
        self.full = [[self.petData objectForKey:@"hpbase"] intValue] + 
        [[self.petData objectForKey:@"hpmult"] intValue] * level; 
        
        // flag for new pet, with -1
        if (hp < 0)
            self.hp = self.full;
        else
            self.hp = hp;
        
        self.attack = [[self.petData objectForKey:@"attackbase"] intValue] + 
        [[self.petData objectForKey:@"attackmult"] intValue] * level; 
        self.defense = [[self.petData objectForKey:@"defensebase"] intValue] + 
        [[self.petData objectForKey:@"defensemult"] intValue] * level; 
        self.speed = [[self.petData objectForKey:@"speedbase"] intValue] + 
        [[self.petData objectForKey:@"speedmult"] intValue] * level; 
        self.special = [[self.petData objectForKey:@"specialbase"] intValue] + 
        [[self.petData objectForKey:@"specialmult"] intValue] * level; 
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

    NSString *name = [petsOfType objectAtIndex:(arc4random() 
                      % petsOfType.count)];
    int approxLevel = level;
    if (level >= 4)
    {
        approxLevel += (arc4random() % (level/4)) - (level/2);
    }
    
    self.petData = [pets objectForKey:name];
    
    NSDictionary *actionDict = [self.petData objectForKey:@"actions"];
    
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
                        andHp:-1
                       andExp:0 
                   andActions:myActions];
    
}

// Level up a pet and return the array of new actions (might be more than the allotted 4!)
- (NSArray *)levelUp
{
    // increase level
    self.level += 1;
    
    // fix xp
    self.exp -= 100;
    
    // restore hp
    self.hp = self.full;
    
    // construct array of action names
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSArray *action in self.actions)
        [actions addObject:[action objectAtIndex:0]];
    
    // retrieve all possible actions
    NSDictionary *actionDict = [self.petData objectForKey:@"actions"];

    
    
    // Find new actions to learn.
    NSArray *newKeys = 
    [[actionDict allKeys] filteredArrayUsingPredicate: 
     [NSPredicate predicateWithBlock:
      ^BOOL(id evaluatedObject, NSDictionary *bindings) 
      {
          return ([evaluatedObject intValue] == self.level);
      }]];
    NSMutableArray *newActions = [[NSMutableArray alloc] init];
    for (NSNumber *key in newKeys)
        [newActions addObject:[actionDict objectForKey:key]];
    
    return [actions arrayByAddingObjectsFromArray:newActions];
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
