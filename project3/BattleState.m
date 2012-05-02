//
//  BattleState.m
//  project3
//
//  Created by Peter Zhang on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "BattleState.h"

@implementation BattleState

@synthesize attack1Message = _attack1Message;
@synthesize attack2Message = _attack2Message;
@synthesize caught = _caught;

- (id)initWithAttack1Message:(NSString *)msg1 
           andAttack2Message:(NSString *)msg2
                   andCaught:(BOOL)caught
{
    self.attack1Message = msg1;
    self.attack2Message = msg2;
    self.caught = caught;
    return self;
}

@end
