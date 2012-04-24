//
//  BattleState.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "BattleState.h"

@implementation BattleState

@synthesize attack1Message = _attack1Message;
@synthesize attack2Message = _attack2Message;

- (id)initWithAttack1Message:(NSString *)msg1 andAttack2Message:(NSString *)msg2
{
    self.attack1Message = msg1;
    self.attack2Message = msg2;
    
    return self;
}

@end
