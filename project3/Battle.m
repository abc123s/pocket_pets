//
//  Battle.m
//  project3
//
//  Created by Peter Zhang on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "Battle.h"
#import "Action.h"
#import "Item.h"
#import "User.h"

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

// Perform two actions
- (BattleState *)doAction1:(NSArray *)action1 andAction2:(NSArray *)action2
{
    float missProb1 = 100. * self.pet2.speed / (self.pet2.speed + self.pet1.speed);
    float missProb2 = 100. - missProb1;
    NSLog([NSString stringWithFormat:@"%f, %f", missProb1, missProb2]);
    NSString *msg1;
    NSString *msg2;
    
    // Pet 1 action
    if ((arc4random() % 100) > missProb1)
    {
        msg1 = [NSString stringWithFormat: @"%@ used %@ on %@. It hits!", 
                self.pet1.name, [action1 objectAtIndex:0], self.pet2.name];
        
        // update health
        self.pet2.hp = self.pet2.hp - [[action1 objectAtIndex: 1] intValue];
        
        //update exp
        self.pet1.exp += (self.pet2.level * 2)/ self.pet1.level;
        
        if (self.pet2.hp < 0)
            self.pet2.hp = 0;
    }
    else 
    {
        msg1 = [NSString stringWithFormat:
                @"%@ used %@ on %@. It misses!", self.pet1.name,
                [action1 objectAtIndex:0], self.pet2.name];
    }
    
    // Pet 2 action; none if dead
    if (self.pet2.hp == 0)
    {
        msg2 = [NSString stringWithFormat:@"%@ has died!", self.pet2.name];
    }
    else if ((arc4random() % 100) > missProb2)
    {
        msg2 = [NSString stringWithFormat:@"%@ used %@ on %@. It hits!", 
                self.pet2.name, [action2 objectAtIndex:0], self.pet1.name];
        
        self.pet1.hp = self.pet1.hp - [[action2 objectAtIndex: 1] intValue];
              
        if (self.pet1.hp < 0)
            self.pet1.hp = 0;
    }
    else 
    {
        msg2 = [NSString stringWithFormat: @"%@ used %@ on %@. It misses!", 
                      self.pet2.name, [action2 objectAtIndex:0], self.pet1.name];
    }
    BattleState *curState = [[BattleState alloc] initWithAttack1Message:msg1
                                                      andAttack2Message:msg2 
                                                              andCaught:NO
                                                                andFlee:NO];
    return curState;
}          

// Use item and perform action
- (BattleState *)useItem1:(NSDictionary *)item1 andAction2:(NSArray *)action2
{
    float missProb2 = 100. * self.pet1.speed / (self.pet1.speed + self.pet2.speed);
    
    NSString *msg1;
    NSString *msg2;
    BOOL caught = NO;
    
    NSString *itemName = [item1 objectForKey:@"name"];
    NSString *itemType = [item1 objectForKey:@"type"];
    
    // Pet 1 item
    if ([itemType isEqualToString:@"catch"])
    {
        float catchProb1 = 100. / sqrt(((float)self.pet2.speed)/10.) * 
        ((float)self.pet2.full - (float)self.pet2.hp) / ((float) self.pet2.full) * 
        [[item objectForKey:itemtype] floatValue];
        if ((arc4random() % 100) > catchProb1)
        {
            msg1 = [NSString stringWithFormat:@"You threw %@ at %@. It worked!", 
                    itemName, self.pet1.name];
            caught = YES;
        }
        else 
        {
            msg1 = [NSString stringWithFormat: @"You threw %@ at %@. It failed!", 
                itemName, self.pet2.name];
        }
    }
    else if ([itemType isEqualToString:@"heal"])
    {
        self.pet1.hp = MIN (self.pet1.full,
                            self.pet1.hp + [[item1 objectForKey:itemType] intValue]);
        msg1 = [NSString stringWithFormat: @"You used %@ on %@. It worked!", 
                itemName, self.pet1.name];
    }
    
    // Remove the item used
    [User deleteItem:itemName];
    
    // Pet 2 action, nothing if caught
    if (caught)
    {
        msg2 = [NSString stringWithFormat:@"%@ has been caught!", self.pet2.name];
    }
    else if ((arc4random() % 100) > missProb2)
    {
        msg2 = [NSString stringWithFormat:@"%@ used %@ on %@. It hits!", 
                self.pet2.name, [action2 objectAtIndex:0], self.pet1.name];
        
        self.pet1.hp = self.pet1.hp - [[action2 objectAtIndex: 1] intValue];
        
        if (self.pet1.hp < 0)
            self.pet1.hp = 0;
    }
    else 
    {
        msg2 = [NSString stringWithFormat: @"%@ used %@ on %@. It misses!", 
                self.pet2.name, [action2 objectAtIndex:0], self.pet1.name];
    }
    
    BattleState *curState = [[BattleState alloc] initWithAttack1Message:msg1
                                                      andAttack2Message:msg2 
                                                              andCaught:caught
                                                                andFlee:NO];
    return curState;
}

// Flee attempt and action
- (BattleState *)flee:(NSArray *)action2
{
    float missProb2 = 100. * self.pet1.speed / (self.pet1.speed + self.pet2.speed);
    
    NSString *msg1;
    NSString *msg2;
    BOOL flee = NO;
    
    // Pet 1 flee attempt
    float fleeProb = 100. / sqrt(((float)self.pet1.speed)/10) * (self.pet1.full - self.pet1.hp) / self.pet1.full;
    if ((arc4random() % 100) > fleeProb)
    {
        msg1 = [NSString stringWithFormat:@"You successfully fled!"];
        flee = YES;
    }
    else 
    {
        msg1 = [NSString stringWithFormat: @"You attempted to flee, but failed!"];
    }

    // Pet 2 action, nothing if caught
    if (flee)
    {
        msg2 = [NSString stringWithFormat:@"%@ is left standing alone!", self.pet2.name];
    }
    else if ((arc4random() % 100) > missProb2)
    {
        msg2 = [NSString stringWithFormat:@"%@ used %@ on %@. It hits!", 
                self.pet2.name, [action2 objectAtIndex:0], self.pet1.name];
        
        self.pet1.hp = self.pet1.hp - [[action2 objectAtIndex: 1] intValue];
        
        if (self.pet1.hp < 0)
            self.pet1.hp = 0;
    }
    else 
    {
        msg2 = [NSString stringWithFormat: @"%@ used %@ on %@. It misses!", 
                self.pet2.name, [action2 objectAtIndex:0], self.pet1.name];
    }
    
    BattleState *curState = [[BattleState alloc] initWithAttack1Message:msg1
                                                      andAttack2Message:msg2 
                                                              andCaught:NO
                                                                andFlee:flee];
    return curState;
}


@end
