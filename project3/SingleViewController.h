//
//  SingleViewController.h
//  project3
//
//  Created by Will Sun on 4/24/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattleViewController.h"

@interface SingleViewController : UIViewController <BattleViewControllerDelegate>
{
    int pageNumber;
}

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *level;
@property (nonatomic, weak) IBOutlet UILabel *atk;
@property (nonatomic, weak) IBOutlet UILabel *def;
@property (nonatomic, weak) IBOutlet UILabel *spd;
@property (nonatomic, weak) IBOutlet UILabel *spc;
@property (nonatomic, weak) IBOutlet UILabel *exp;
@property (nonatomic, weak) IBOutlet UIProgressView *hp;
@property (nonatomic, weak) IBOutlet UIImageView *petImage;

@property (nonatomic, assign) int pageNumber;

- (id)initWithPageNumber:(int)page;
- (IBAction)battle:(id)sender;

@end