//
//  ActionViewController.h
//  project3
//
//  Created by Will Sun on 5/2/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionViewController;

@protocol ActionViewControllerDelegate
- (void)actionViewControllerBack:(ActionViewController *)controller;
- (void)actionViewControllerDidFinish:(ActionViewController *)controller withAction:(NSArray *)action;
- (NSArray *)passActions; 
@end

@interface ActionViewController : UIViewController <UITableViewDataSource,
                                                    UITableViewDelegate>

@property (weak, nonatomic) id <ActionViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *actions;


- (id)initWithNibName:(NSString *)nibNameOrNil 
           controller:(id)controller
               bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)back:(id)sender;

@end
