//
//  UserPets.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "UserPets.h"

@implementation UserPets

// Return false if there is a previous game going on
+ (BOOL)noPets
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"pets"])
        return NO;
    else 
        return YES;
}

// Create new NSUserDefaults with first pet
+ (void)initNewWithName:(NSString *)name
{
    // create the first pet
    NSArray *actions = [NSArray arrayWithObject: @"Tackle"];
    NSDictionary *pet = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name",
                                                                    [NSNumber numberWithInt:1] , @"level", 
                                                                    [NSNumber numberWithInt:-1], @"hp",
                                                                    [NSNumber numberWithInt:0], @"xp", 
                                                                    actions, @"actions", nil];
    
    /* EXTRA PETS */
    NSDictionary *petx = [NSDictionary dictionaryWithObjectsAndKeys: @"Bulbasaur", @"name",
                         [NSNumber numberWithInt:1] , @"level", 
                         [NSNumber numberWithInt:-1], @"hp",
                         [NSNumber numberWithInt:0], @"xp", 
                         actions, @"actions", nil];
    NSDictionary *pety = [NSDictionary dictionaryWithObjectsAndKeys: @"Pikachu", @"name",
                          [NSNumber numberWithInt:1] , @"level", 
                          [NSNumber numberWithInt:-1], @"hp",
                          [NSNumber numberWithInt:0], @"xp", 
                          actions, @"actions", nil];
    
    // create pets dictionary
    NSMutableDictionary *pets = [[NSMutableDictionary alloc] init];
    [pets setObject:pet forKey:[pet objectForKey:@"name"]];
    
    /* EXTRAS */
    [pets setObject:petx forKey:[petx objectForKey:@"name"]];
    [pets setObject:pety forKey:[pety objectForKey:@"name"]];
    
    // create user dictionary
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setObject:pets forKey:@"pets"];
    
    // register user
    NSMutableDictionary *placeholder = [[NSMutableDictionary alloc] init];
    [placeholder setObject:@"" forKey:@"pets"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:placeholder];
    
    // save new pets
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pets forKey:@"pets"];
    [defaults synchronize];
}

// Create new user pet
+ (void)initWithName:(NSString *)name
{
    // create pet
    NSArray *actions = [NSArray arrayWithObject: @"Tackle"];
    NSDictionary *pet = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name",
                         [NSNumber numberWithInt:1] , @"level", 
                         [NSNumber numberWithInt:-1], @"hp",
                         [NSNumber numberWithInt:0], @"xp", 
                         actions, @"actions", nil];
    
    // update pets dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // TODO: validation to ensure no duplicates?
    [[defaults objectForKey:@"pets"] setObject:pet forKey:[pet objectForKey:@"name"]];
    [defaults synchronize];
}


// Return array of user pets
+ (NSArray *)currentPets
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve pets
    NSArray *pets = [[defaults objectForKey:@"pets"] allValues];
    
    // construct array
    NSMutableArray *new = [NSMutableArray arrayWithCapacity:7];
    for (NSDictionary *pet in pets) 
    {
        [new addObject:[[Pet alloc] initWithName:[pet objectForKey:@"name"]
                                        andLevel:[[pet objectForKey:@"level"] intValue]
                                           andHp:[[pet objectForKey:@"hp"] intValue]
                                          andExp:[[pet objectForKey:@"xp"] intValue]
                                      andActions:[pet objectForKey:@"actions"]]];
    }
     
    return new;
}

// Retrieve info on a given pet
+ (Pet *)findPetWithName:(NSString *)name
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve pet
    NSDictionary *target = [[defaults objectForKey:@"pets"] objectForKey:name];

    // create pet
    return [[Pet alloc] initWithName:[target objectForKey:@"name"]
                            andLevel:[[target objectForKey:@"level"] intValue]
                               andHp:[[target objectForKey:@"hp"] intValue]
                              andExp:[[target objectForKey:@"xp"] intValue]
                          andActions:[target objectForKey:@"actions"]];
}

// Save pet info
+ (void)savePet:(Pet *)pet
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve pets
    NSMutableDictionary *pets = [[NSMutableDictionary alloc] init];
    [pets addEntriesFromDictionary:[defaults objectForKey:@"pets"]];
    
    // retrieve pet
    NSMutableDictionary *target = [[NSMutableDictionary alloc] init];
    [target addEntriesFromDictionary:[pets objectForKey:pet.name]];
    [target setObject:[NSNumber numberWithInt:pet.level] forKey:@"level"];
    [target setObject:[NSNumber numberWithInt:pet.hp] forKey:@"hp"];
    [target setObject:[NSNumber numberWithInt:pet.exp] forKey:@"xp"];
    
    NSMutableArray *realActions = [NSMutableArray arrayWithCapacity:4];
    for (NSArray *action in pet.actions) {
        [realActions addObject:[action objectAtIndex:0]];
    }
    [target setObject:realActions forKey:@"actions"];
    
    // save
    [pets setObject:target forKey:pet.name];
    [defaults setObject:pets forKey:@"pets"];
    [defaults synchronize];
}

@end
