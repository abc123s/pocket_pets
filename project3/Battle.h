//
//  Battle.h
//  project3
//
//  Created by Peter Zhang on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"
#import "BattleState.h"

@interface Battle : NSObject {
}

- (id)initWithPet1:(Pet *)pet1 andPet2:(Pet *)pet2;

// Attack
- (BattleState *)doAction1:(NSArray *)action1 andAction2:(NSArray *)action2;

// Use item
- (BattleState *)useItem1:(NSDictionary *)item1 andAction2:(NSArray *)action2;

// Flee attempt
- (BattleState *)flee:(NSArray *)action2;

@end
