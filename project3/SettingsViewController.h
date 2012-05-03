//
//  SettingsViewController.h
//  project3
//
//  Created by Will Sun on 5/3/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) id <SettingsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;


- (id)initWithNibName:(NSString *)nibNameOrNil 
           controller:(id)controller
               bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)done:(id)sender;

@end
