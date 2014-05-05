//
//  BioEditViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 28/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "BioEditViewController.h"

@interface BioEditViewController ()

@end

@implementation BioEditViewController
@synthesize isTapped;
@synthesize m_CharacterLabel;
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
    self.m_BioTextView.contentInset = UIEdgeInsetsMake(-60,0.0,0,0.0);
    m_CharacterLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 30)];
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [m_CharacterLabel setTextColor:kGrayColor];
    [backView setBackgroundColor:[UIColor clearColor]];
    [backView addSubview:m_CharacterLabel];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backView];
    
    
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItems=@[backButtonItem,rightButtonItem];
    
    isTapped=NO;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.title=@"Bio";
[self.m_BioTextView becomeFirstResponder];
    
    NSString *valueStr=[[NSString stringWithFormat:@"%@",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"tagline"]] stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
    NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
    [self.m_BioTextView setText:valueEmoj1];
    if (valueStr.length==0) {
        self.m_BioTextView.text=@"";
    }
    m_CharacterLabel.text=[NSString stringWithFormat:@"%u",279-valueEmoj1.length];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
}
-(void)becameFirstResponder
{
     [self.m_BioTextView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapped:(UITapGestureRecognizer*)gesture
{
    [self.view endEditing:YES];
}
#pragma TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    isTapped=YES;
    if (location != NSNotFound){
        [self.m_CharacterLabel setText:[NSString stringWithFormat:@"%u",279-range.location]];
        [textView resignFirstResponder];
        return NO;
    }
    
    if (text.length<=0) {
        [self.m_CharacterLabel setText:[NSString stringWithFormat:@"%u",279-range.location]];
        return YES;
    }

    
    if (textView.text.length<281 || [text isEqualToString:@"\n"]) {
        [self.m_CharacterLabel setText:[NSString stringWithFormat:@"%u",279-range.location]];
     
    }
    else
    {
        [self.view endEditing:YES];
        return NO;
    }

    return YES;
}
-(void)editBioDetails
{
    NSData *data11 = [self.m_BioTextView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    NSString *valueUnicode = [[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
    NSString *valueStr=[valueUnicode stringByReplacingOccurrencesOfString:@"\\" withString:@"-"];

    
    NSString *bodyString=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kTagLineString,valueStr];
    
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kEditTagLine AndRequestBody:bodyString];
    if ([[dict objectForKey:@"return"] intValue]==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dict objectForKey:@"totalImageset"] == [NSNull null]) {
     
    
                NSMutableDictionary *dictmain=[[NSMutableDictionary alloc] initWithDictionary:dict];
                [dictmain setObject:@"0" forKey:@"totalImageset"];
                [[NSUserDefaults standardUserDefaults] setObject:dictmain forKey:@"userinfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
          
        
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"editProfile" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageEdit" object:nil];
        });
    }
    else
    {
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isTapped==YES) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self editBioDetails];
        });
    }
   
}
@end
