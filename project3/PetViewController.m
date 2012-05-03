//
//  PetViewController.m
//  project3
//
//  Created by Will Sun on 4/23/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "PetViewController.h"
#import "SingleViewController.h"
#import "BattleViewController.h"
#import "Pet.h"
#import "User.h"

@interface PetViewController ()

// helpers for alert view on level up
@property (strong, nonatomic) NSMutableArray *heldActions;
@property (assign, nonatomic) BOOL filter;
@property (strong, nonatomic) NSString *heldName;
@property (assign, nonatomic) int heldLevel;
@property (assign, nonatomic) int heldHp;
@property (assign, nonatomic) int heldExp;

- (void)show;
- (void)loadScrollViewWithPage:(int)page;

@end

@implementation PetViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize battle = _battle;
@synthesize viewControllers = _viewControllers;
@synthesize pets = _pets;
@synthesize pages = _pages;

@synthesize heldActions = _heldActions;
@synthesize filter = _filter;
@synthesize heldName = _heldName;
@synthesize heldLevel = _heldLevel;
@synthesize heldHp = _heldHp;
@synthesize heldExp = _heldExp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Pets", @"Pets");
        self.tabBarItem.image = [UIImage imageNamed:@"23-bird"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)show
{
    // PRINT DEFAULTS
    /*
    NSLog(@"%@ defaults = %@", [self class], 
          [[NSUserDefaults standardUserDefaults] 
           persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]);
    */
    
    // Retrieve all pets
    self.pets = [User currentPets];
    
    // Find number of user pets
    self.pages = [self.pets count];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self.pages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pages, 
                                             self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = self.pages;
    self.pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page
{
    // out-of-bounds
    if (page < 0)
        return;
    if (page >= self.pages)
        return;
    
    // replace the placeholder if necessary
    SingleViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[SingleViewController alloc] initWithPageNumber:page];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        Pet *selected = [self.pets objectAtIndex:page];
        controller.petImage.image = [UIImage imageNamed:selected.spritePath];
        controller.name.text = selected.name;
        controller.level.text = [NSString stringWithFormat:@"%d", selected.level];
        controller.atk.text = [NSString stringWithFormat:@"%d", selected.attack];
        controller.def.text = [NSString stringWithFormat:@"%d", selected.defense];
        controller.spd.text = [NSString stringWithFormat:@"%d", selected.speed];        
        controller.spc.text = [NSString stringWithFormat:@"%d", selected.special];
        controller.exp.progress = (float)selected.exp / 100.;
        controller.hp.progress = (float)selected.hp / (float)selected.full;
        
        [self.scrollView addSubview:controller.view];
    }
    
    // Hide the battle button if the pet is dead...
    if ([self passPet].hp == 0)
        self.battle.enabled = NO;
    else 
        self.battle.enabled = YES;
    
}

- (IBAction)changePage:(id)sender
{
    int page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (IBAction)battle:(id)sender
{
    BattleViewController *controller = [[BattleViewController alloc] 
                                        initWithNibName:@"BattleViewController"
                                        controller:self
                                        bundle:nil];
    
    [self presentModalViewController:controller animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.filter)
    {
        // remove selected action
        for (NSUInteger i = 0; i < [self.heldActions count]; i++)
        {
            if (buttonIndex == i)
                [self.heldActions removeObjectAtIndex:i];
        }
        
        // save new pet
        [User savePet:[[Pet alloc] initWithName:self.heldName
                                       andLevel:self.heldLevel
                                          andHp:self.heldHp 
                                         andExp:self.heldExp 
                                     andActions:self.heldActions]];
    }
    else 
    {
        [self dismissModalViewControllerAnimated:YES];
        [self show];
    }
}


#pragma mark - BattleViewControllerDelegate
- (void)battleViewControllerDidFinish:(BattleViewController *)controller withPet:(Pet *)pet
{
    BOOL lvl = (pet.exp > 100);
    if (lvl)
    {        
        // level up the pet
        self.heldActions = [NSArray arrayWithArray:[pet levelUp]];
        
        // discard one of the actions
        if ([self.heldActions count] > 4)
        {
            self.filter = YES;
                    
            // save pet info for alert view
            self.heldName = [NSString stringWithFormat:@"%@", pet.name];
            self.heldLevel = pet.level;
            self.heldHp = pet.hp;
            self.heldExp = pet.exp;

            // show alert to pick action to discard
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level Up!"
                                                            message:@"Please pick action to discard"                                                     
                                                           delegate:self
                                                  cancelButtonTitle:nil                                                        
                                                  otherButtonTitles:nil];
            // add buttons
            for (NSUInteger i = 0; i < [self.heldActions count]; i++)
                [alert addButtonWithTitle:[self.heldActions objectAtIndex:i]];
            
            [alert show];
        }
        else
        {
            self.filter = NO;
            
            // save leveled-up pet
            [User savePet:[[Pet alloc] initWithName:pet.name
                                           andLevel:pet.level
                                              andHp:pet.hp 
                                             andExp:pet.exp 
                                         andActions:self.heldActions]];
            
            // show congratulations alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level Up!"
                                                            message:[NSString 
                                                                        stringWithFormat:@"%@ is stronger!", pet.name]                                                    
                                                           delegate:self
                                                  cancelButtonTitle:@"Great!"                                         
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        [User savePet:pet];
        [self dismissModalViewControllerAnimated:YES];
        [self show];
    }
    
}

- (Pet *)passPet
{
    return [self.pets objectAtIndex:self.pageControl.currentPage];
}


#pragma mark - scrollview

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

@end