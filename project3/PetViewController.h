//
//  PetViewController.h
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattleViewController.h"
#import "SettingsViewController.h"

@interface PetViewController : UIViewController <UIScrollViewDelegate, 
                                                UIAlertViewDelegate,
                                                BattleViewControllerDelegate,
                                                SettingsViewControllerDelegate> 
{
    BOOL pageControlUsed;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *battle;

@property (strong, nonatomic) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSArray *pets;
@property (assign, nonatomic) NSUInteger pages;

- (IBAction)changePage:(id)sender;
- (IBAction)battle:(id)sender;
- (IBAction)settings:(id)sender;

@end
