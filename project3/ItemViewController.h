//
//  ItemViewController.h
//  project3
//
//  Created by Will Sun on 5/3/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ItemViewController;

@protocol ItemViewControllerDelegate
- (void)itemViewControllerBack:(ItemViewController *)controller;
- (void)itemViewControllerDidFinish:(ItemViewController *)controller withItem:(NSString *)item;
@end

@interface ItemViewController : UIViewController <UITableViewDataSource,
                                                  UITableViewDelegate>

@property (weak, nonatomic) id <ItemViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *items;


- (id)initWithNibName:(NSString *)nibNameOrNil 
           controller:(id)controller
               bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)back:(id)sender;

@end
