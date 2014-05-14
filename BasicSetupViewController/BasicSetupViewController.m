//
//  BasicSetupViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 18/02/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "BasicSetupViewController.h"

@interface BasicSetupViewController ()

@end

@implementation BasicSetupViewController
@synthesize m_HeadingArray;
@synthesize m_HeadingLabel;
@synthesize m_SetupScrollView;
@synthesize pageNumber;
@synthesize headingLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    m_HeadingArray=[[NSArray alloc] initWithObjects:@"I like...",@"That are Located Within",@"Age Range",@"A bit about me", @"Bio", @"Edit Photos", nil];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
         [self.m_SetupScrollView setContentSize:CGSizeMake(320*5, kBasicScrollHeight_iPhone5-100)];
    }
    else
    {
         [self.m_SetupScrollView setContentSize:CGSizeMake(320*5, kBasicScrollHeight_iPhone4-100)];
    }
 
    [self setUpScrollview];
    //[self performSelector:@selector(hideKeyboard)withObject:nil afterDelay:0.01];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      [self performSelector:@selector(hideKeyboard)withObject:nil afterDelay:0.01];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyboard
{
     [self.view endEditing:YES];
}
-(void)setUpScrollview
{
    headingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 6, 320, 50)];
    headingLabel.textAlignment=NSTextAlignmentCenter;
    [headingLabel setFont:[UIFont fontWithName:@"Helvetica" size:19]];
    [headingLabel setTextColor:kRedColor];
    [headingLabel setText:[self.m_HeadingArray objectAtIndex:0]];

    for (int i=0; i<5; i++) {
        
        if (i<3) {
            if([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568)
            {
            self.m_DetailedVC=[[DetailedSettingsViewController alloc] initWithNibName:@"DetailedSettingsViewController" bundle:nil];
                  self.m_DetailedVC.indexNumber=i+1;
                 self.m_DetailedVC.view.frame = CGRectMake(320*i, 0, 320, kBasicScrollHeight_iPhone5);
            }
            else
            {
               self.m_DetailedVC=[[DetailedSettingsViewController alloc] initWithNibName:@"DetailedSettingsViewController_iPhone4" bundle:nil];
                  self.m_DetailedVC.indexNumber=i+1;
                 self.m_DetailedVC.view.frame = CGRectMake(320*i, 0, 320, kBasicScrollHeight_iPhone4);
            }
            
            NSLog(@"value : %i", self.m_DetailedVC.indexNumber);
           [self addChildViewController: self.m_DetailedVC];
            
            [self.view addSubview: self.m_DetailedVC.view];
            [ self.m_DetailedVC didMoveToParentViewController:self];
            if (i==1) {
            [self.m_DetailedVC.m_DetailedTableView setFrame:CGRectMake(0, 0, 320, 360)];
            }
            else{
            [self.m_DetailedVC.m_DetailedTableView setFrame:CGRectMake(0, 0, 320, 120)];
            }

            [self.m_SetupScrollView addSubview: self.m_DetailedVC.view];
        }
        else if(i==3)
        {
           
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
                self.m_BioVC=[[BioEditViewController alloc] initWithNibName:@"BioEditViewController" bundle:nil];
                self.m_BioVC.view.frame = CGRectMake(320*i, 0, 320, kBasicScrollHeight_iPhone5);
            }
            else
            {
                self.m_BioVC=[[BioEditViewController alloc] initWithNibName:@"BioEditViewController_iPhone4" bundle:nil];
                self.m_BioVC.view.frame = CGRectMake(320*i, 0, 320, kBasicScrollHeight_iPhone4);
            }
           
            [self addChildViewController:self.m_BioVC];
     
            [self.view addSubview:self.m_BioVC.view];
            [self.m_BioVC didMoveToParentViewController:self];
            [self.m_SetupScrollView addSubview:self.m_BioVC.view];
             self.m_BioVC.m_BioTextView.contentInset = UIEdgeInsetsMake(-120,0.0,0,0.0);
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
                self.m_AddImageVC=[[AddImagesViewController alloc] initWithNibName:@"AddImagesViewController" bundle:nil];
                            self.m_AddImageVC.view.frame = CGRectMake(320*i,0, 320, kBasicScrollHeight_iPhone5);
            }
            else
            {
                self.m_AddImageVC=[[AddImagesViewController alloc] initWithNibName:@"AddImagesViewController_iPhone4" bundle:nil];
                self.m_AddImageVC.view.frame = CGRectMake(320*i, 0, 320, kBasicScrollHeight_iPhone4);
            }
            [self addChildViewController:self.m_AddImageVC];

            [self.view addSubview:self.m_AddImageVC.view];
            [self.m_AddImageVC didMoveToParentViewController:self];
            [self.m_SetupScrollView addSubview:self.m_AddImageVC.view];
        }
        
    }
     [self.view addSubview:headingLabel];
    
    [self.view endEditing:YES];
}
#pragma ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.m_SetupScrollView.frame.size.width;
    pageNumber = floor((self.m_SetupScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.m_PageControl.currentPage=pageNumber;
    switch (pageNumber) {
        case 0:
            [headingLabel setText:[self.m_HeadingArray objectAtIndex:0]];
            break;
        case 1:
            [headingLabel setText:[self.m_HeadingArray objectAtIndex:1]];
            break;
        case 2:
            [headingLabel setText:[self.m_HeadingArray objectAtIndex:2]];
            break;
            
        case 3:
            [headingLabel setText:[self.m_HeadingArray objectAtIndex:4]];
            break;
        case 4:
            [headingLabel setText:[self.m_HeadingArray objectAtIndex:5]];
            break;
        default:
            break;
    }

    
       }

- (IBAction)nextButtonClicked:(id)sender {
    AppDelegate *Appdel;

    switch (pageNumber) {
        case 0:
            [headingLabel setText:[self.m_HeadingArray objectAtIndex:0]];
            self.m_DetailedVC.indexNumber=1;
            [self.m_DetailedVC editDetails];
            break;
            
        case 1:
             [headingLabel setText:[self.m_HeadingArray objectAtIndex:1]];
            self.m_DetailedVC.indexNumber=2;
            [self.m_DetailedVC editDetails];
            break;
        case 2:
             [headingLabel setText:[self.m_HeadingArray objectAtIndex:2]];
            self.m_DetailedVC.indexNumber=3;
            [self.m_DetailedVC editDetails];
            [self.m_BioVC.m_BioTextView becomeFirstResponder];
            break;
            
        case 3:
             [headingLabel setText:[self.m_HeadingArray objectAtIndex:4]];
            [self.m_BioVC editBioDetails];
            [self.view endEditing:YES];
            break;
            
        case 4:
            Appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            [Appdel initializeTabBar];
            break;
            
        default:
            break;
    }
    int page = self.m_PageControl.currentPage+1;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.m_SetupScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.m_SetupScrollView scrollRectToVisible:frame animated:YES];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
    CGFloat pageWidth = self.m_SetupScrollView.frame.size.width;
    pageNumber = floor((self.m_SetupScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Page Number : %i",pageNumber);
    self.m_PageControl.currentPage=pageNumber;
 

}
- (IBAction)pageControlClicked:(id)sender {
    int page = self.m_PageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.m_SetupScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.m_SetupScrollView scrollRectToVisible:frame animated:YES];
}
@end
