//
//  Item.m
//  project3
//
//  Created by Peter Zhang on 5/2/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "Item.h"

@implementation Item

// Return dictionary representing a single item
+ (NSDictionary *)lookupItemWithName:(NSString *)name 
{
    // load dictionary of base items
    NSDictionary *items = [NSDictionary dictionaryWithContentsOfFile: 
                              [[NSBundle mainBundle] pathForResource:@"items" 
                                                              ofType:@"plist"]];
    // find our move
    NSDictionary *myitem = [items objectForKey:name];
    
    return myitem;
}

// Return of array of items for store
+ (NSArray *)store
{
    // load dictionary of base items
    NSDictionary *items = [NSDictionary dictionaryWithContentsOfFile: 
                           [[NSBundle mainBundle] pathForResource:@"items" 
                                                           ofType:@"plist"]];

    // prepare structure
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSString *itemName in [items allKeys])
    {
        NSString *itemType = [[items objectForKey:itemName] objectForKey:@"type"];
        NSDictionary *new = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"name",
                                                                       itemType, @"type",
                             [[items objectForKey:itemName] objectForKey:itemType], itemType, nil];
        [list addObject:new];
    }
    
    return list;
}
@end
