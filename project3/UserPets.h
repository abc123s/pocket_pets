//
//  UserPets.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPets : NSObject

@property (strong, nonatomic) NSArray *petList;

// Return true if there is a previous game going on
+ (BOOL)anyPets;

// Create a new user plist of pets with a first pet
+ (void)initWithName:(NSString *)name;

// Return array of user pets
+ (NSArray *)currentPets;

@end
