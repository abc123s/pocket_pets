//
//  UserPets.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"
#import "Item.h"

@interface User : NSObject

// Return true if there is no previous game
+ (BOOL)noPets;

// Create a new NSUserDefaults with a first pet
+ (void)initNewWithName:(NSString *)name;

// PETS:
// Add new pet
+ (void)createPet:(Pet *)pet;

// Return array of user pets
+ (NSArray *)currentPets;

// Update pet
+ (void)savePet:(Pet *)pet;

// ITEMS:
// Add new item
+ (void)addItem:(NSString *)item;

// Return array of user items
+ (NSArray *)currentItems;

// Delete item
+ (void)deleteItem:(NSString *)item;

// DEBUG:
// Retrieve altitude
+ (float)getAlt;

// Set altitude
+ (void)setAlt:(float)alt;

@end
