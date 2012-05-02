//
//  Item.m
//  project3
//
//  Created by Peter Zhang on 5/2/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (NSDictionary *)lookupItemWithName:(NSString *)name 

{
    // load dictionary of base moves
    NSDictionary *items = [NSDictionary dictionaryWithContentsOfFile: 
                              [[NSBundle mainBundle] pathForResource:@"items" 
                                                              ofType:@"plist"]];
    // find our move
    NSDictionary *myitem = [items objectForKey:name];
    
    return myitem;
}

@end
