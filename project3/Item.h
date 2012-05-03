//
//  Item.h
//  project3
//
//  Created by Peter Zhang on 5/2/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject {
}

// Return dictionary representing specific item
+ (NSDictionary *)lookupItemWithName:(NSString *)name; 

// Return array of dictionaries for each item possible
+ (NSArray *)store;

@end
