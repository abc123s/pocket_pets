//
//  Action.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject {
}

+ (int)lookupMoveDamageWithName:(NSString *)name 
                andAttack:(int)attack
               andDefense:(int)defense
                 andSpeed:(int)speed 
               andSpecial:(int)special;

@end
