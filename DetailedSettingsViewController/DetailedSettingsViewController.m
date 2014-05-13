//
//  DetailedSettingsViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 28/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "DetailedSettingsViewController.h"

@interface DetailedSettingsViewController ()

@end

@implementation DetailedSettingsViewController
@synthesize m_MenuArray;
@synthesize isTapped;
@synthesize m_MinLabel;
@synthesize m_MaxLabel;
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
       isTapped=NO;
    self.m_MethodArray=[[NSArray alloc] initWithObjects:kEditGender,kEditGenderType,kEditRadius,kEditAge, nil];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :kRedColor}];
    m_MenuArray=[[NSMutableArray alloc] init];
    NSArray *array;
    NSArray *ageArray;
    NSString *mainString;
    switch (self.indexNumber) {
       // CGRect frame=self.m_DetailedTableView.frame;
        case 0:
            array=[NSArray arrayWithObjects:@"Man",@"Woman", nil];
            self.navigationItem.title=@"I am...";
            [m_MenuArray addObjectsFromArray:array];


            if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"gender"] isEqualToString:@"Man"]) {
                self.selectedValue=0;
            }
            else
            {
                self.selectedValue=1;
            }
            [self.m_DetailedTableView setFrame:CGRectMake(0, 0, 320, 58*m_MenuArray.count)];
           // frame.size.height=100;
          //  self.m_DetailedTableView.frame=frame;
            break;
          
            case 1:
            array=[NSArray arrayWithObjects:@"Men",@"Women", nil];
            [m_MenuArray addObjectsFromArray:array];
            self.navigationItem.title=@"I like...";
            if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"genderType"] isEqualToString:@"Men"]) {
                self.selectedValue=0;
            }
            else
            {
                self.selectedValue=1;
            }
            [self.m_DetailedTableView setFrame:CGRectMake(0, 0, 320, 60*m_MenuArray.count)];
           // frame.size.height=100;
           // self.m_DetailedTableView.frame=frame;
            break;
            
            case 2:
            array=[NSArray arrayWithObjects:@"less than 5 mi.",@"10 mi.",@"30 mi.",@"50 mi.",@"70 mi.",@"90 mi.", nil];
            [m_MenuArray addObjectsFromArray:array];
            self.navigationItem.title=@"Proximity";
            if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] isEqualToString:@"5.00"]) {
                self.selectedValue=0;
            }
            else if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] isEqualToString:@"10.00"])
            {
                self.selectedValue=1;
            }
            else if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] isEqualToString:@"30.00"])
            {
                self.selectedValue=2;
            }
            else if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] isEqualToString:@"50.00"])
            {
                self.selectedValue=3;
            }
            else if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] isEqualToString:@"70.00"])
            {
                self.selectedValue=4;
            }
            else if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] isEqualToString:@"90.00"])
            {
                self.selectedValue=5;
            }
            [self.m_DetailedTableView setFrame:CGRectMake(0, 0, 320, 60*m_MenuArray.count)];
            break;
        case 3:
            self.navigationItem.title=@"Age Range";
         
            self.m_AgeSlider=[[NMRangeSlider alloc] initWithFrame:CGRectMake(15, 15, 290, 30)];
            [self.m_AgeSlider addTarget:self action:@selector(labelSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [self configureMetalSlider];
            [self updateSliderLabels];
            mainString=[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"age"];
            ageArray=[mainString componentsSeparatedByString:@"-"];
            self.m_AgeSlider.lowerValue=[[ageArray objectAtIndex:0] floatValue];
            self.m_AgeSlider.upperValue=[[ageArray objectAtIndex:1] floatValue];
            
            
            //[self.m_DetailedTableView setFrame:CGRectMake(0, 0, 320, 60*2)];
            break;
            
        default:
            
            break;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"Identifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (self.indexNumber<3) {
    cell.textLabel.text=[self.m_MenuArray objectAtIndex:indexPath.row];
    }
    else if (self.indexNumber==3)
    {
        if (indexPath.row==0) {
        
        NSString *mainString=[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"age"];
        NSArray *ageArray=[mainString componentsSeparatedByString:@"-"];
        m_MinLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
        [m_MinLabel setTextColor:[UIColor blackColor]];
        [m_MinLabel setText:[ageArray objectAtIndex:0]];
        
        m_MaxLabel=[[UILabel alloc] initWithFrame:CGRectMake(270, 15, 30, 30)];
        [m_MaxLabel setTextColor:[UIColor blackColor]];
        [m_MaxLabel setText:[ageArray objectAtIndex:1]];
        
        [cell.contentView addSubview:m_MinLabel];
        [cell.contentView addSubview:m_MaxLabel];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 59, 320, 1)];
            [label setBackgroundColor:[UIColor grayColor]];
            
        }
        else
        {
            NSString *mainString=[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"age"];
            NSArray *ageArray=[mainString componentsSeparatedByString:@"-"];
            self.m_AgeSlider.lowerValue=[[ageArray objectAtIndex:0] floatValue];
            self.m_AgeSlider.upperValue=[[ageArray objectAtIndex:1] floatValue];
            [cell.contentView addSubview:self.m_AgeSlider];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
           
            
        }
    }
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 59, 320, 1)];
//    [label setBackgroundColor:[UIColor grayColor]];
//    [cell.contentView addSubview:label];

      return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isTapped=YES;
    self.selectedValue=indexPath.row;
    [self.m_DetailedTableView reloadData];
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedValue forKey:@"value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indexNumber<3) {
        
    if (self.selectedValue ==indexPath.row) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checked"]];
    } else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotChecked"]];
    }
    }
      }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.indexNumber<3) {
    return m_MenuArray.count;
    }
    else
    {
        return 2;
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    if (isTapped==YES) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self editDetails];
        });}}

-(void)editDetails{
    NSString *bodyString;
     NSString *stringName;
    NSString *finalAgeString;
    switch (self.indexNumber) {
        case 0:
            switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"value"]) {
                case 0:
                stringName=@"Man";
                    break;
                case 1:
                    stringName=@"Woman";
                    break;
                    
                default:
                     stringName=@"Woman";
                    break;
            }
            
            bodyString=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kGenderString,stringName];
            
            break;
            
            case 1:
            switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"value"]) {
                case 0:
                    stringName=@"Men";
                    break;
                    
                case 1:
                    stringName=@"Women";
                    break;
                    
                default:
                     stringName=@"Women";
                    break;
            }

             bodyString=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kGenderTypeString,stringName];
            
            break;
            
            case 2:
            switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"value"]) {
                case 0:
                    stringName=@"5";
                    break;
                    
                    case 1:
                     stringName=@"10";
                    break;
                    
                    case 2:
                     stringName=@"30";
                    break;
                    
                    case 3:
                     stringName=@"50";
                    break;
                    case 4:
                     stringName=@"70";
                    break;
                    case 5:
                     stringName=@"90";
                    break;
                    
                default:
                     stringName=@"50";
                    break;
            }
           
              bodyString=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kRadiusString,stringName];
            
            break;
            
            case 3:
            
     finalAgeString=[[NSString stringWithFormat:@"%@-",self.m_MinLabel.text ] stringByAppendingString:self.m_MaxLabel.text];
            
            bodyString=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kAgeString,finalAgeString];
            break;
            
        default:
            break;
    }
    
    
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:[self.m_MethodArray objectAtIndex:self.indexNumber] AndRequestBody:bodyString];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editProfile" object:nil];
    });
    }
    else
    {
        
    }
}

- (void) updateSliderLabels
{
    isTapped=YES;
    CGPoint lowerCenter;
    lowerCenter.x = (self.m_AgeSlider.lowerCenter.x + self.m_AgeSlider.frame.origin.x);
    lowerCenter.y = 20.0f;
    self.m_MinLabel.center = lowerCenter;
    
    CGPoint upperCenter;
    upperCenter.x = (self.m_AgeSlider.upperCenter.x + self.m_AgeSlider.frame.origin.x);
    upperCenter.y =  20.0f;
    self.m_MaxLabel.center = upperCenter;

    self.m_MinLabel.text = [NSString stringWithFormat:@"%d", (int)self.m_AgeSlider.lowerValue];
    
    self.m_MaxLabel.text = [NSString stringWithFormat:@"%d", (int)self.m_AgeSlider.upperValue];
}
- (void)labelSliderChanged:(NMRangeSlider*)sender
{

    [self updateSliderLabels];
    
}
#pragma mark -
#pragma mark - Standard Slider





// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Metal Theme Slider

- (void) configureMetalThemeForSlider:(NMRangeSlider*) slider
{
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"GreyTint"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    slider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"BlackTint"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    slider.trackImage = image;
    
    image = [UIImage imageNamed:@"slider-default-handle"];
    slider.lowerHandleImageNormal = image;
    slider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider-default-handle-highlighted"];
    slider.lowerHandleImageHighlighted = image;
    slider.upperHandleImageHighlighted = image;
}

- (void) configureMetalSlider
{
    [self configureMetalThemeForSlider:self.m_AgeSlider];
    
    self.m_AgeSlider.minimumValue = 18;
    self.m_AgeSlider.maximumValue = 70;

    
    self.m_AgeSlider.minimumRange = 1;
}

// ------------------------------------------------------------------------------------------------------
-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
           if ([view isKindOfClass:[NMRangeSlider class]]) {
            return NO;
        }
        else {
            return YES;
        }
    

}

@end
