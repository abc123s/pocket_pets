//
//  Pet.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pet : NSObject {
}

// Pet properties:

@property (assign, nonatomic) int level;
@property (assign, nonatomic) int hp;
@property (assign, nonatomic) int full;
@property (assign, nonatomic) int exp;
@property (assign, nonatomic) int attack;
@property (assign, nonatomic) int defense;
@property (assign, nonatomic) int speed;
@property (assign, nonatomic) int special;

@property (strong, nonatomic) NSMutableString *name;
@property (strong, nonatomic) NSMutableString *type;
@property (strong, nonatomic) NSMutableArray *actions; 
@property (strong, nonatomic) NSString *spritePath;
@property (strong, nonatomic) NSString *battlePath;
@property (strong, nonatomic) NSString *oppPath;
@property (strong, nonatomic) NSDictionary *petData;




// Pet functions:

// Initialize a new pet.
- (id)initWithName:(NSString *)name 
          andLevel:(int)level
             andHp:(int)hp
            andExp:(int)exp
          andActions:(NSArray *)actions;

// Initialize a random pet.
- (id)initRandomWithLevel:(int)level 
                  andType:(NSString *)type;

// Level up the current pet, returning an array of actions to choose
// from if applicable.
- (NSArray *)levelUp;

// Update the pet's actions. 
- (void)updateActions:(NSArray *)actions; 

@end