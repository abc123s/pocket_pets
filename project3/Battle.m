//
//  Battle.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "Battle.h"
#import "Action.h"

@interface Battle ()

// Game instance variables: game state, word length, word being guessed

@property (strong, nonatomic) Pet *pet1;
@property (strong, nonatomic) Pet *pet2;

@end


@implementation Battle

@synthesize pet1 = _pet1;
@synthesize pet2 = _pet2;

- (id)initWithPet1:(Pet *)pet1 andPet2:(Pet *)pet2
{
    self.pet1 = pet1;
    self.pet2 = pet2;
    
    return self;
}

- (BattleState *)doAction1:(NSString *)action1 andAction2:(NSString *)action2
{
    float missProb1 = 100. * self.pet2.speed / (self.pet2.speed + self.pet1.speed);
    float missProb2 = 100. - missProb1;
    NSString *msg1;
    NSString *msg2;
    if ((arc4random() % 100) > missProb1)
    {
        msg1 = [NSString stringWithFormat: @"%@ used %@ on %@. It hits!", 
                self.pet1.name, action1, self.pet2.name];
        
        self.pet2.hp = self.pet2.hp - 
        [Action lookupMoveDamageWithName:action1 
                               andAttack:self.pet1.attack 
                              andDefense:self.pet1.defense
                                andSpeed:self.pet1.speed
                              andSpecial:self.pet1.special];
        if (self.pet2.hp < 0)
            self.pet2.hp = 0;
    }
    else 
    {
        msg1 = [NSString stringWithFormat:
                @"%@ used %@ on %@. It misses!", self.pet1.name,
                action1, self.pet2.name];
    }
    if ((arc4random() % 100) > missProb2)
    {
        msg2 = [NSString stringWithFormat:@"%@ used %@ on %@. It hits!", 
                self.pet2.name, action2, self.pet1.name];
        
        self.pet1.hp = self.pet1.hp - 
        [Action lookupMoveDamageWithName:action2 
                               andAttack:self.pet2.attack 
                              andDefense:self.pet2.defense
                                andSpeed:self.pet2.speed
                              andSpecial:self.pet2.special];
        if (self.pet1.hp < 0)
            self.pet1.hp = 0;
    }
    else 
    {
        msg2 = [NSString stringWithFormat: @"%@ used %@ on %@. It misses!", 
                self.pet2.name, action2, self.pet1.name];
    }
    
    BattleState *curState = [[BattleState alloc] initWithAttack1Message:msg1
                                                      andAttack2Message:msg2];
    return curState;
}

@end
