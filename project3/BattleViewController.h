//
//  BattleViewController.h
//  project3
//
//  Created by Will Sun on 4/24/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Pet.h"
#import "ActionViewController.h"
#import "ItemViewController.h"

@class BattleViewController;

@protocol BattleViewControllerDelegate
- (void)battleViewControllerDidFinish:(BattleViewController *)controller withPet:(Pet *)pet;
- (Pet *)passPet; 
@end

@interface BattleViewController : UIViewController <UIAlertViewDelegate,
                                                    CLLocationManagerDelegate, 
                                                    NSXMLParserDelegate,
                                                    ActionViewControllerDelegate,
                                                    ItemViewControllerDelegate>                                          

@property (weak, nonatomic) id <BattleViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *proPetName;
@property (weak, nonatomic) IBOutlet UILabel *oppPetName;
@property (weak, nonatomic) IBOutlet UILabel *proPetHP;
@property (weak, nonatomic) IBOutlet UILabel *oppPetHP;
@property (weak, nonatomic) IBOutlet UIProgressView *proPetBar;
@property (weak, nonatomic) IBOutlet UIProgressView *oppPetBar;
@property (weak, nonatomic) IBOutlet UIImageView *proPetPic;
@property (weak, nonatomic) IBOutlet UIImageView *oppPetPic;
@property (weak, nonatomic) IBOutlet UILabel *msg;

- (id)initWithNibName:(NSString *)nibNameOrNil 
           controller:(id)controller
               bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)attack:(id)sender;
- (IBAction)flee:(id)sender;
- (IBAction)item:(id)sender;

@end
