//
//  ConversationViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 09/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "ConversationViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "WebServiceAPIController.h"
#import "UIButton+AFNetworking.h"

@interface ConversationViewController ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL _reloading;
}
@property(nonatomic)int m_pageNumber;
@property (weak, nonatomic) IBOutlet UILabel *m_MessageText;
@property(nonatomic)BOOL IsPageNumberSet;
@end

@implementation ConversationViewController
@synthesize m_ConversationArray;
@synthesize m_MessageTimer;
@synthesize isFirst;
@synthesize isChecked;
@synthesize isSuccess;
@synthesize IsPageNumberSet;
@synthesize isRefresh;
@synthesize isPaused;
@synthesize m_MessageDictionary;
@synthesize m_MessageLoadingView;
@synthesize m_Body;
@synthesize m_MessageField;
@synthesize m_TextView;
#pragma mark - Message View Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Allocation of Arrays

- (void)AllocateArrays
{
    m_ConversationArray=[[NSMutableArray alloc] init];
    self.m_MybubbleData=[[NSBubbleData alloc] init];
    self.m_OtherBubbleData=[[NSBubbleData alloc] init];
}

- (void)Setboolvalues
{
    
    isRefresh=NO;
    IsPageNumberSet=NO;
    isSuccess=YES;
    isFirst=YES;
    _m_pageNumber=1;
    isSuccess=YES;
}

- (void)Setupheaderpic
{
    

UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
[backView setBackgroundColor:[UIColor clearColor]];



    UIButton *picButton=[[UIButton alloc] initWithFrame:CGRectMake(15, 5, 35, 35)];
    
    [picButton addTarget:self action:@selector(profileClicked) forControlEvents:UIControlEventTouchUpInside];
    [picButton setBackgroundColor:[UIColor clearColor]];
    [[picButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
    picButton.layer.cornerRadius=3.0f;
    picButton.clipsToBounds=YES;
    [picButton setBackgroundImageForState:UIControlStateNormal withURL:[self.m_userInfo objectForKey:@"userimage"] placeholderImage:[UIImage imageNamed:@"No preview"]];
    [backView addSubview:picButton];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    UIButton *Namebtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [Namebtn setBackgroundColor:[UIColor clearColor]];
    Namebtn.titleLabel.font=[UIFont boldSystemFontOfSize:17.0f];
    [Namebtn addTarget:self action:@selector(profileClicked) forControlEvents:UIControlEventTouchUpInside];
    [Namebtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [Namebtn setTitle:[NSString stringWithFormat:@"%@, %@",[self.m_userInfo objectForKey:@"first_name"],[self.m_userInfo objectForKey:@"age"]] forState:UIControlStateNormal];
    
    self.navigationItem.titleView=Namebtn;
}



#pragma mark - View DidLoad Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self AllocateArrays];
    [self Setboolvalues];
   
    self.m_ConversationTable.bubbleDataSource=self;
    self.m_ConversationTable.scrollEnabled=YES;

    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [backView setBackgroundColor:[UIColor clearColor]];
   // _refreshHeaderView.hidden=YES;
  
    [self Setupheaderpic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClicked:)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    [self.m_ActivityIndicator startAnimating];
    [self StartTimerForConversation];
   //
    
    }

-(void)setNav
{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil action:nil];
   [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

}
-(void)tapGestureClicked:(UITapGestureRecognizer*)tapGesture
{
    [self.view endEditing:YES];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self stopTimerForConversation];
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   [self.tabBarController.tabBar setHidden:YES];
    self.tabBarController.hidesBottomBarWhenPushed=YES;
    [self setNav];
    
//    [self StartTimerForConversation];
 

}
-(void)StartTimerForConversation
{
   m_MessageTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fetchConversation) userInfo:nil repeats:YES];
}
//#pragma TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_ConversationArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSBubbleData *bubble=[[NSBubbleData alloc] init];
    bubble=[self.m_ConversationArray objectAtIndex:indexPath.row];
    return bubble.view.frame.size.height*2;
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [m_ConversationArray count];
  
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [m_ConversationArray objectAtIndex:row];
}


- (void)Loadingconverstion
{
    if (isPaused==NO) {
        
        self.m_ConversationTable.bubbleDataSource=self;
            NSString *timeZone=[[NSTimeZone localTimeZone] name];
            NSString *body=[NSString stringWithFormat:@"%@%@%@%@%@%i%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kOtherUserID,[self.m_userInfo objectForKey:@"userid"],kPageString,self.m_pageNumber,kTimeZoneString,timeZone];
            
            NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kGetAllMessages AndRequestBody:body];
            NSString*response=[NSString stringWithFormat:@"%@",[dict objectForKey:@"reason"]];
            
            if ([response isEqualToString:@"success"]) {
                
                m_MessageDictionary=[[NSMutableDictionary alloc] initWithDictionary:dict];
                [self updateUI:dict];
                
            }
        
    }

}


-(void)fetchConversation
{
    
    [self performSelectorInBackground:@selector(Loadingconverstion) withObject:nil];

}

-(NSString*)Emojistr:(NSString*)str
{
    
    NSString *valueStr=[str stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
    NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
    return valueEmoj1;
}


-(void)updateUI:(NSDictionary *)dict
{
    
    if (isPaused==NO) {
    
        [self.m_MessageLoadingView stopAnimating];
        
          dispatch_async(dispatch_get_main_queue(), ^{
              
              [m_ConversationArray removeAllObjects];
              
    if ([[dict objectForKey:@"return"] intValue]==1) {
  
            isSuccess=YES;
            IsPageNumberSet=YES;
        
            for (int i=0; i<[[dict objectForKey:@"data"] count]; i++) {
                
                if ([[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_me"] isEqualToString:@"yes"]) {
                    
                NSString*valueemoji=[self Emojistr:[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"messages"]];
                self.m_OtherBubbleData=[NSBubbleData dataWithText:valueemoji date:[NSDate dateWithTimeIntervalSinceNow:-290]  type:NSBubbleTypingTypeSomebody];
                [self.m_ConversationArray addObject:self.m_OtherBubbleData];
                    
                }
                else
                {
                    
                NSString *valueEmoj1=[self Emojistr:[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"messages"]];
                  self.m_MybubbleData=[NSBubbleData dataWithText:valueEmoj1 date:[NSDate dateWithTimeIntervalSinceNow:-290]  type:NSBubbleTypingTypeMe];
                [self.m_ConversationArray addObject:self.m_MybubbleData];
                }
            }
        
        
         [self.m_ConversationTable reloadData];
         self.previousCount=self.m_ConversationArray.count;            //
        
        if (isFirst==YES) {
            
            [self.m_ActivityIndicator stopAnimating];
            
            isFirst=NO;
                if (m_ConversationArray.count>0) {
                   NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([m_ConversationArray count]) inSection:0];
                    [[self m_ConversationTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
            else
            {
                if (self.previousCount<self.m_ConversationArray.count) {
                    
                    if (m_ConversationArray.count>0) {
                        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([m_ConversationArray count]) inSection:0];
                        [[self m_ConversationTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
                
            }
    }
          });
    }
}
#pragma Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (void)Sendmessage
{
    
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kSendMessage AndRequestBody:self.m_Body];
    
    
        if ([[dict objectForKey:@"return"] intValue]==1) {
        
        for (int i=0; i<[[dict objectForKey:@"data"] count]; i++) {
            
            if ([[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_me"] isEqualToString:@"yes"]) {
                
            NSString *valueEmoj1 =[self Emojistr:[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"messages"]];
            self.m_OtherBubbleData=[NSBubbleData dataWithText:valueEmoj1 date:[NSDate dateWithTimeIntervalSinceNow:-290]  type:NSBubbleTypingTypeSomebody];
            
            [self.m_ConversationArray addObject:self.m_OtherBubbleData];
                
                
            }
            else
            {
               NSString *valueEmoj1 =[self Emojistr:[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"messages"]];
                
                self.m_MybubbleData=[NSBubbleData dataWithText:valueEmoj1 date:[NSDate dateWithTimeIntervalSinceNow:-290]  type:NSBubbleTypingTypeMe];
                [self.m_ConversationArray addObject:self.m_MybubbleData];
                
            }
            
        }
        
        [self.m_ConversationTable reloadData];
        
        if (self.m_ConversationArray.count>0) {
            
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([m_ConversationArray count]) inSection:0];
            [[self m_ConversationTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        
    }
    
    else
    {
        UIAlertView*m_Message=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Some problem in sending message" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [m_Message show];
    }

    
}

- (void)Initiatemessage
{
    isPaused=YES;
    
    [m_ConversationArray removeAllObjects];
    m_ConversationArray=nil;
    m_ConversationArray=[[NSMutableArray alloc] init];
    self.m_MybubbleData=nil;
    self.m_OtherBubbleData=nil;
    self.m_MybubbleData=[[NSBubbleData alloc] init];
    self.m_OtherBubbleData=[[NSBubbleData alloc] init];
    
    
    NSString*message=[NSString stringWithFormat:@"%@",m_TextView.text];
    message=[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    if (message.length>0) {
        
        NSData *data11 = [self.m_MessageField.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *valueUnicode = [[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
        NSString *valueStr=[valueUnicode stringByReplacingOccurrencesOfString:@"\\" withString:@"-"];
        NSString *timeZoneName = [[NSTimeZone localTimeZone] name];
        
        NSString *body=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kOtherUserID,[self.m_userInfo objectForKey:@"userid"],kMessageSting,valueStr,kTimeZoneString,timeZoneName];
        self.m_Body=body;
        
        [self performSelectorInBackground:@selector(Sendmessage) withObject:Nil];
        
        
    }
    
    isPaused=NO;

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSelector:@selector(Initiatemessage) withObject:Nil afterDelay:0.2];
       return YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
   
    return YES;
}


#pragma mark - Keyboard events



- (void)keyboardWasShown:(NSNotification*)aNotification

{
  
    
       NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
        
      

        CGRect frame = self.m_TextviewBackground.frame;
        
        frame.origin.y -= kbSize.height;
        
        self.m_TextviewBackground.frame = frame;
        
        
       
        frame = self.m_ConversationTable.frame;
        
        frame.size.height -= kbSize.height;
        
        self.m_ConversationTable.frame = frame;

        if (self.previousCount>0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(self.previousCount ) inSection:0];
            [[self m_ConversationTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
       

    }];
    
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
   
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
        
        
        CGRect frame = self.m_TextviewBackground.frame;
        
        frame.origin.y += kbSize.height;
        
        self.m_TextviewBackground.frame = frame;
        
       
        
        frame = self.m_ConversationTable.frame;
        
        frame.size.height += kbSize.height;
        
        self.m_ConversationTable.frame = frame;
        if (self.previousCount>0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(self.previousCount) inSection:0];
            [[self m_ConversationTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
  
        }
          }];
    
}

-(void)profileClicked
{
    UserDetailsViewController *userDetailsVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
    }
    else
    {
        userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone4" bundle:nil];
    }
    
    userDetailsVC.hidesBottomBarWhenPushed=NO;
    userDetailsVC.m_userProfile=(NSMutableDictionary*)self.m_userInfo;
    userDetailsVC.ischat=YES;
    userDetailsVC.isChecked=YES;
    [self.navigationController pushViewController:userDetailsVC animated:YES];
}


- (void)Addrefreshtable
{
    if (_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.m_ConversationTable.bounds.size.height, self.view.frame.size.width, self.m_ConversationTable.bounds.size.height)];
        view.delegate = self;
        [self.m_ConversationTable addSubview:view];
        _refreshHeaderView = view;
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)addButton
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [view setBackgroundColor:kRedColor];
    view.userInteractionEnabled=YES;
    UIButton *previousChatButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [previousChatButton addTarget:self action:@selector(refreshNext) forControlEvents:UIControlEventTouchUpInside];
    [previousChatButton setBackgroundColor:[UIColor clearColor]];
    [previousChatButton setTitle:@"Click to load more messages" forState:UIControlStateNormal];
    [previousChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_MessageLoadingView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 4, 37, 37)];
    [m_MessageLoadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    m_MessageLoadingView.hidesWhenStopped=YES;
    
    [view addSubview:previousChatButton];
    [view addSubview:m_MessageLoadingView];
//    [self.m_ConversationTable addSubview:view];
    self.m_ConversationTable.tableHeaderView=view;
    }
-(void)refreshNext
{
    self.m_pageNumber++;
    [m_MessageLoadingView startAnimating];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];

    
}
- (void)reloadTableView
{
    [self.m_ConversationTable reloadData];
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
   // [self performSelectorInBackground:@selector(fetchConversation) withObject:nil];
    [self performSelector:@selector(fetchConversation) withObject:nil afterDelay:2.0f];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.m_ConversationTable];
    isRefresh=YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //Pull to refresh begin
   // [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    //for Nav/TabBar Scroll begin
    //CGFloat currentOffset = scrollView.contentOffset.y;
    //CGFloat differenceFromStart = startContentOffset - currentOffset;
   // CGFloat differenceFromLast = lastContentOffset - currentOffset;
   // differenceFromLast = currentOffset;
    
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
   IsPageNumberSet=YES;
    isRefresh=YES;
    self.m_pageNumber++;
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0f];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

-(void)expand
{
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)contract
{
    
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
   // self.m_ConversationTable.delegate=nil;
   // _refreshHeaderView.delegate=nil;
}

-(void)stopTimerForConversation
{
    [self.m_MessageTimer invalidate];
    self.m_MessageTimer=nil;
}
#pragma TextView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.m_MessageText.text=@"";
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
        self.m_MessageText.text=@"Message";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    isPaused=YES;
    
    if (textView.text.length>0) {
        
       
        if ([text isEqualToString:@"\n"]) {
 
            [m_ConversationArray removeAllObjects];
//            m_ConversationArray=nil;
//            m_ConversationArray=[[NSMutableArray alloc] init];
//            self.m_MybubbleData=nil;
//            self.m_OtherBubbleData=nil;
//            self.m_MybubbleData=[[NSBubbleData alloc] init];
//            self.m_OtherBubbleData=[[NSBubbleData alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
                   NSData *data11 = [self.m_TextView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
            NSString *valueUnicode = [[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
            NSString *valueStr=[valueUnicode stringByReplacingOccurrencesOfString:@"\\" withString:@"-"];
            
            NSString *timeZoneName = [[NSTimeZone localTimeZone] name];
            NSString *body=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kOtherUserID,[self.m_userInfo objectForKey:@"userid"],kMessageSting,valueStr,kTimeZoneString,timeZoneName];
            
            NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kSendMessage AndRequestBody:body];
            
            if ([[dict objectForKey:@"return"] intValue]==1) {
                
                for (int i=0; i<[[dict objectForKey:@"data"] count]; i++) {
                    
                    if ([[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_me"] isEqualToString:@"yes"]) {
                        
                        NSString *stringValue=[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"messages"];
                        NSString *valueStr=[stringValue stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
                        
                        NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
            
                        NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
                        
                        self.m_OtherBubbleData=[NSBubbleData dataWithText:valueEmoj1 date:[NSDate dateWithTimeIntervalSinceNow:-290]  type:NSBubbleTypingTypeSomebody];
                        [self.m_ConversationArray addObject:self.m_OtherBubbleData];
                        
                        
                    }
                    else
                    {
                        NSString *stringValue=[[[dict objectForKey:@"data"] objectAtIndex:i] objectForKey:@"messages"];
                        NSString *valueStr=[stringValue stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
                        //self.m_TagelineTextView.text=valueStr;
                        
                        NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
                        
                        self.m_MybubbleData=[NSBubbleData dataWithText:valueEmoj1 date:[NSDate dateWithTimeIntervalSinceNow:-290]  type:NSBubbleTypingTypeMe];
                        [self.m_ConversationArray addObject:self.m_MybubbleData];
                        
                    }
                    
                }
                textView.text=@"";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_ConversationTable reloadData];
                    if (self.m_ConversationArray.count>0) {
                        
                        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([m_ConversationArray count]) inSection:0];
                        [[self m_ConversationTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        [self.m_TextView setText:@""];
                    }
                    

                });

                
                
            }
            
            else
            {
                
            }

    });
                       return NO;
        }
        
    }
    isPaused=NO;
    return YES;
    }

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
@end
