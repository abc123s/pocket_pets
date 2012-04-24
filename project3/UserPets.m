//
//  UserPets.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "UserPets.h"
#import "Pet.h"

@implementation UserPets

// Return true if there is a previous game going on
+ (BOOL)anyPets
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"pets"])
        return YES;
    else 
        return NO;
}

// Create new NSUserDefaults with first pet
+ (void)initNewWithName:(NSString *)name
{
    // create the first pet
    NSArray *actions = [NSArray arrayWithObject: @"Tackle"];
    NSDictionary *pet = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name",
                                                                    [NSNumber numberWithInt:1] , @"level", 
                                                                    [NSNumber numberWithInt:0], @"xp", 
                                                                    actions, @"actions", nil];
    
    // create pets dictionary
    NSMutableDictionary *pets = [[NSMutableDictionary alloc] init];
    [pets setObject:pet forKey:[pet objectForKey:@"name"]];
    
    // create user dictionary
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setObject:pets forKey:@"pets"];
    
    // register user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:user];
}

// Create new user pet
+ (void)initWithName:(NSString *)name
{
    // create pet
    NSArray *actions = [NSArray arrayWithObject: @"Tackle"];
    NSDictionary *pet = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name",
                         [NSNumber numberWithInt:1] , @"level", 
                         [NSNumber numberWithInt:0], @"xp", 
                         actions, @"actions", nil];
    
    // create pets dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *pets = [defaults objectForKey:@"pets"];
    
    // TODO: validation to ensure no duplicates?
    [pets setObject:pet forKey:[pet objectForKey:@"name"]];
    
    // register new pet
    [defaults setObject:pets forKey:@"pets"];    
}


// Return array of user pets
+ (NSArray *)currentPets
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve pets
    NSMutableDictionary *pets = [defaults objectForKey:@"pets"];
    
    // construct array
    return [pets allValues];
}

@end
