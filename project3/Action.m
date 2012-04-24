//
//  Action.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "Action.h"

@implementation Action

+ (int)lookupMoveDamageWithName:(NSString *)name 
                      andAttack:(int)attack
                     andDefense:(int)defense
                       andSpeed:(int)speed 
                     andSpecial:(int)special
{
    // load dictionary of base moves
    NSDictionary *moves = [NSDictionary dictionaryWithContentsOfFile: 
                          [[NSBundle mainBundle] pathForResource:@"moves" 
                                                          ofType:@"plist"]];
    // find our move
    NSDictionary *mymove = [moves objectForKey:name];
    
    // calculate total damage dealt by move
    int damage = [[mymove objectForKey:@"damagebase"] intValue] + 
    [[mymove objectForKey:@"attackmult"] intValue] * attack +
    [[mymove objectForKey:@"defensemult"] intValue] * defense +
    [[mymove objectForKey:@"speedmult"] intValue] * speed +
    [[mymove objectForKey:@"specialmult"] intValue] * special; 
    
    return damage;
}
@end
