//
//  BattleState.h
//  project3
//
//  Created by Peter Zhang on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BattleState : NSObject {
}

@property (weak, nonatomic) NSString *attack1Message;
@property (weak, nonatomic) NSString *attack2Message;
@property (assign, nonatomic) BOOL caught;

- (id)initWithAttack1Message:(NSString *)msg1 
           andAttack2Message:(NSString *)msg2
                   andCaught:(BOOL)caught;

@end
