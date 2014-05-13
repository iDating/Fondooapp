//
//  AddImagesViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 28/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "AddImagesViewController.h"

@interface AddImagesViewController ()
{
     SharedClass *data;
}
@end

@implementation AddImagesViewController
@synthesize m_ImagesDictionary;
@synthesize isFirst;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (isFirst==NO) {
        
    [self.m_ActivityIndicator startAnimating];
        isFirst=NO;
    }
    else
        
    {
        [self.m_ActivityIndicator stopAnimating];
        isFirst=NO;
    }
    [self performSelector:@selector(endEditingView) withObject:nil afterDelay:0.01];
}

-(void)endEditingView
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view endEditing:YES];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:self.m_ActivityIndicator];
    self.navigationItem.rightBarButtonItem=rightItem;
    [self.m_ActivityIndicator startAnimating];
    isFirst=YES;
    /*
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        self.m_ScrollView.contentSize=CGSizeMake(320, 580);
    }
    else
    {
        self.m_ScrollView.contentSize=CGSizeMake(320, 480);
    }
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTempImage:) name:@"setImage" object:nil];
    self.navigationItem.title=@"Edit Photos";
    m_ImagesDictionary=[[NSMutableDictionary alloc] initWithDictionary:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"img"]];
    [self initializeView];

      // Do any additional setup after loading the view from its nib.
}
-(void)setTempImage:(NSNotification*)notify
{
    
    [self initializeView];
    
}
-(void)initializeView
{
    [self.m_ActivityIndicator startAnimating];
     m_ImagesDictionary=[[NSMutableDictionary alloc] initWithDictionary:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"img"]];
    int cnt = 0;
    for (int i=0; i<[m_ImagesDictionary count]; i++) {
        UIButton *btn = [self.m_changeButtons objectAtIndex:i];
        if ([[[m_ImagesDictionary objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"imageset"] isEqualToString:@"yes"]) {
            [btn setImage:[UIImage imageNamed:@"EditImage_Frame"] forState:UIControlStateNormal];
            
            UIImageView *img = [self.m_ImageViews objectAtIndex:i];
            [img setImage:nil];
            [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[m_ImagesDictionary objectForKey:[NSString stringWithFormat:@"image%i",i]]objectForKey:@"url"]]] placeholderImage:[UIImage imageNamed:@"PrieviewImage"]];
            cnt++;
        }
        else
        {
            if (i == cnt)
                [btn setImage:[UIImage imageNamed:@"Frame_Add"] forState:UIControlStateNormal];
            else
                [btn setHidden:YES];
        }
    }
    [self.m_ActivityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeImageClicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    AlbumsCollectionViewController *albumVC;
   
    data=[SharedClass sharedInstance];
    [data setM_ImageNumber:[NSString stringWithFormat:@"%i",(btn.tag+1)-10]];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        albumVC=[[AlbumsCollectionViewController alloc] initWithNibName:@"AlbumsCollectionViewController" bundle:nil];
        
    }
    else
    {
        albumVC=[[AlbumsCollectionViewController alloc] initWithNibName:@"AlbumsCollectionViewController_iPhone4" bundle:nil];
    }
    
    UINavigationController *navBar=[[UINavigationController alloc] initWithRootViewController:albumVC];
    [self presentViewController:navBar animated:YES completion:nil];

}
- (IBAction)deleteImage:(id)sender {
    UIButton *btn=(UIButton*)sender;
 [self.m_ActivityIndicator startAnimating];
    NSString *body=[NSString stringWithFormat:@"%@%@&img%i",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],btn.tag+1];
    
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kDeleteImage AndRequestBody:body];
    if ([[dict objectForKey:@"return"] intValue]==1) {
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
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageEdit" object:nil];
        for (UIImageView *image in self.m_ScrollView.subviews) {
            if ([[image class] isSubclassOfClass:[UIImageView class]]) {
                if ( image.tag==btn.tag) {
                    [image setImage:nil];
                    
                }
                
            }
                }
        
        for (UIButton * button in self.m_ScrollView.subviews) {
            if ([[button class] isSubclassOfClass:[UIButton class]]) {
                if ( button.tag==btn.tag+10) {
                    [button setBackgroundImage:nil forState:UIControlStateNormal];
                    [button setImage:nil forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"Frame_Add"] forState:UIControlStateNormal];
                }
                
            }
        }
        
    }
    else{
        
    }
     [self.m_ActivityIndicator stopAnimating];
}
@end
