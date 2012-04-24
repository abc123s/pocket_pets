//
//  Battle.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"
#import "BattleState.h"
@interface Battle : NSObject {
}

- (id)initWithPet1:(Pet *)pet1 andPet2:(Pet *)pet2;

- (BattleState *)doAction1:(NSString *)action1 andAction2:(NSString *)action2;

@end
