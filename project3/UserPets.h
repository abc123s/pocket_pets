//
//  UserPets.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"

@interface UserPets : NSObject

// Return true if there is no previous game
+ (BOOL)noPets;

// Create a new NSUserDefaults with a first pet
+ (void)initNewWithName:(NSString *)name;

// Add new pet
+ (void)initWithName:(NSString *)name;

// Return array of user pets
+ (NSArray *)currentPets;

// Find specific pet
+ (Pet *)findPetWithName:(NSString *) name;

// Update pet
+ (void)savePet:(Pet *)pet;

@end
