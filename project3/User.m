//
//  User.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "User.h"

@implementation User

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
    /*
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
    */
     
    // create pets dictionary
    NSMutableDictionary *pets = [[NSMutableDictionary alloc] init];
    [pets setObject:pet forKey:[pet objectForKey:@"name"]];
    
    /* EXTRAS */
    /*
    [pets setObject:petx forKey:[petx objectForKey:@"name"]];
    [pets setObject:pety forKey:[pety objectForKey:@"name"]];
    */
     
    // create default items
    NSArray *items = [NSArray arrayWithObjects:@"Potion", @"Potion", @"Pokeball", nil];
    
    // register user
    NSMutableDictionary *placeholder = [[NSMutableDictionary alloc] init];
    [placeholder setObject:@"" forKey:@"pets"];
    [placeholder setObject:@"" forKey:@"items"];
    [placeholder setObject:@"" forKey:@"alt"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:placeholder];
    
    // save new pets
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pets forKey:@"pets"];
    [defaults setObject:items forKey:@"items"];
    
    [defaults synchronize];
}

// Create new user pet
+ (void)createPet:(Pet *)pet
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve pets
    NSMutableDictionary *pets = [[NSMutableDictionary alloc] init];
    [pets addEntriesFromDictionary:[defaults objectForKey:@"pets"]];
    
    // parse actions (pet.actions is array of tuples)
    NSMutableArray *realActions = [NSMutableArray arrayWithCapacity:4];
    for (NSArray *action in pet.actions) 
    {
        [realActions addObject:[action objectAtIndex:0]];
    }

    // create pet; note that it starts with 0 xp 
    NSDictionary *target = [NSDictionary dictionaryWithObjectsAndKeys: pet.name, @"name",
                         [NSNumber numberWithInt:pet.level] , @"level", 
                         [NSNumber numberWithInt:pet.hp], @"hp",
                         [NSNumber numberWithInt:0], @"xp", 
                         realActions, @"actions", nil];
    
    // save
    [pets setObject:target forKey:pet.name];
    [defaults setObject:pets forKey:@"pets"];
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
    [target setObject:[NSNumber numberWithInt:pet.hp] forKey:@"hp"];
    [target setObject:[NSNumber numberWithInt:pet.level] forKey:@"level"];
    [target setObject:[NSNumber numberWithInt:pet.exp] forKey:@"xp"];
    
    // parse actions (pet.actions stores an array of tuples)
    NSMutableArray *realActions = [NSMutableArray arrayWithCapacity:4];
    for (NSArray *action in pet.actions) 
    {
        [realActions addObject:[action objectAtIndex:0]];
    }
    [target setObject:realActions forKey:@"actions"];
    
    // save
    [pets setObject:target forKey:pet.name];
    [defaults setObject:pets forKey:@"pets"];
    [defaults synchronize];
}

// ITEMS:
// Add new item
+ (void)addItem:(NSString *)item
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve items
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObjectsFromArray:[defaults objectForKey:@"items"]];
    
    // add new item
    [items addObject:item];
    
    // save
    [defaults setObject:items forKey:@"items"];
    [defaults synchronize];
}

// Return array of user items (as dictionaries)
+ (NSArray *)currentItems
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // re-construct items as array of dictionaries (with name, type, heal/catch)
    NSArray *items = [NSArray arrayWithArray:[defaults objectForKey:@"items"]];
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (NSString *item in items)
    {
        NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithCapacity:3];
        [newItem addEntriesFromDictionary:[Item lookupItemWithName:item]];
        [newItem setObject:item forKey:@"name"];
        
        [newItems addObject:newItem];
    }
    
    return newItems;
}

// Delete item
+ (void)deleteItem:(NSString *)item
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve items
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObjectsFromArray:[defaults objectForKey:@"items"]];
    
    // delete item
    for (NSUInteger i = 0; i < [items count]; i++)
    {
        if ([[items objectAtIndex:i] isEqualToString:item])
        {
            [items removeObjectAtIndex:i];
            break;
        }
    }
    
    // save
    [defaults setObject:items forKey:@"items"];
    [defaults synchronize];
}

// DEBUG:
// Get artificial altitude
+ (float)getAlt
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve altitude
    return [[defaults objectForKey:@"alt"] floatValue];
}

// Set artificial altitude
+ (void)setAlt:(float)alt
{
    // retrieve defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // set altitude
    [defaults setObject:[NSNumber numberWithFloat:alt] forKey:@"alt"];
    [defaults synchronize];
}

@end
