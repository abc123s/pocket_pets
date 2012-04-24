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
    NSDictionary *actions = [NSDictionary dictionaryWithContentsOfFile: 
                          [[NSBundle mainBundle] pathForResource:@"actions" 
                                                          ofType:@"plist"]];
    // find our move
    NSDictionary *myaction = [actions objectForKey:name];
    
    // calculate total damage dealt by move
    int damage = ([[myaction objectForKey:@"damagebase"] intValue] + 
    [[myaction objectForKey:@"attackmult"] intValue] * attack +
    [[myaction objectForKey:@"defensemult"] intValue] * defense +
    [[myaction objectForKey:@"speedmult"] intValue] * speed +
    [[myaction objectForKey:@"specialmult"] intValue] * special)/100; 
    
    return damage;
}
@end
