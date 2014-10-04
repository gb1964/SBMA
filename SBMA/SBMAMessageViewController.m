//
//  SBMAMessageViewController.m
//  SBMA
//
//  Created by gb on 14-7-10.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAMessageViewController.h"
#import "SBJSON.h"
#import "SSKeychain.h"
#import "SBMADataModel.h"
#import "SBMAMMViewController.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface SBMAMessageViewController ()

@end

@implementation SBMAMessageViewController

@synthesize userdata = _userdata;
@synthesize sbmdata = _sbmdata;

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
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setHidden];
    [self startToMove];
    [self getMessage];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) refresh{
    [self startToMove];
    [self getMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cellId_Message";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row)
    {
        case 0 :
            cell.textLabel.text = @"系统消息";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_sbmdata.count];
  //          if (_sbmdata.count == 0)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.textLabel.text = @"用户消息";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_userdata.count];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    switch (indexPath.row)
    {
        case 0 :
            if (_sbmdata.count > 0)
                [self presentNextViewController];
            break;
        case 1:
            if (_userdata.count > 0)
                [self presentNextViewController];
            break;
    }
}

#pragma mark --UITableViewDelegate 协议方法

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark -- UITextFieldDelegate委托方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark -- UITextFieldDelegate委托方法,避免键盘遮挡文本框
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableView setContentOffset:CGPointMake(0.0, cell.frame.origin.y) animated:YES];
}

- (void) getMessage{
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] == NotReachable) {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"警告：网络不通！"message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [unavailAlert show];
        [self startToMove];
        return;
    }
    
    NSArray *temp = [[SSKeychain accountsForService:SBMASERVICENAME]lastObject];
    NSString *user = [temp valueForKey:@"acct"];
    NSString *str = [SBMSet produceURLString:@"msg/message"];
    
    NSMutableString *strURL = [[NSMutableString alloc] initWithCapacity:100];
    
    [strURL setString:str];
    [strURL appendString:@"?"];
    [strURL appendString:@"username"];
    [strURL appendFormat:@"%@",user];

    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSData *envelope = [strURL dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置POST方法
	[request setHTTPMethod:@"GET"];
    
    //设置请求头，Content-Type字段
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头，Content-Length字段
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [request setValue:access_token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSError *err;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response %@", [operation responseString]);
         [self parserResponseData:responseObject error:err];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response %@", [operation responseString]);
         NSLog(@"Error: %@", error);
         [self startToMove];
         return;
     }];
    [operation start];
}

-(void)parserResponseData:(NSData*)datas error:(NSError *) err
{
    if ([datas length] == 0){
        [SBMSet getRefreshToken];
        [self getMessage];
    }
    NSString *responseString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
    SBJSON *json = [[SBJSON alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDic = [json objectWithString:responseString error:&error];
    NSArray *array = [jsonDic objectForKey:@"user_message"];
    if (array.count !=0)
    {
        _userdata = [NSMutableArray array];
        for (NSDictionary *subjson in array)
        {
            UserMessageModel *model = [[UserMessageModel alloc] init];
            model.message = [subjson objectForKey:@"message"];
            model.message_reason = [subjson objectForKey:@"message_reason"];
            model.send_time = [subjson objectForKey:@"send_time"];
            model.title = [subjson objectForKey:@"title"];
            model.message_status = [subjson objectForKey:@"message_status"];
            model.message_from_status = [subjson objectForKey:@"message_from_status"];
            [_userdata addObject:model];
        }
    }
    array = [jsonDic objectForKey:@"sbm_message"];
    if (array.count !=0)
    {
        _sbmdata = [NSMutableArray array];
        for (NSDictionary *subjson in array)
        {
            SBMMessageModel *model = [[SBMMessageModel alloc] init];
            model.message = [subjson objectForKey:@"message"];
            model.send_time = [subjson objectForKey:@"send_time"];
            model.title = [subjson objectForKey:@"title"];
            model.message_status = [subjson objectForKey:@"message_status"];
            model.message_from_status = [subjson objectForKey:@"message_from_status"];
            [_sbmdata addObject:model];
        }
    }
    else{
        NSDictionary *subjson = [jsonDic objectForKey:@"meta"];
        NSString *message = [subjson objectForKeyedSubscript:@"message"];
        NSString *status = [subjson objectForKeyedSubscript:@"mstatus"];
        if ([message isEqualToString:@"The token have no authorization"] && [status isEqualToString:@"2"]){
            [SBMSet getRefreshToken];
            [self getMessage];
        }
        else{
            [self showAlert:@"查询结果为空！" andmsg:nil];
        }
    }
    [self.tableView reloadData];
    [self startToMove];
    return;
}

- (void)showAlert:(NSString *)title andmsg:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SBMAMMViewController *viewController = segue.destinationViewController;
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    if (selectedIndex == 0){
        viewController.titleString = @"系统消息";
        viewController.data = _sbmdata;
    }
    else{
        viewController.titleString = @"用户消息";
        viewController.data = _userdata;
    }
}

- (void)presentNextViewController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SBMAMMViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SBMAMMView"];
    
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    if (selectedIndex == 0){
        viewController.titleString = @"系统消息";
        viewController.data = _sbmdata;
    }
    else{
        viewController.titleString = @"用户消息";
        viewController.data = _userdata;
    }
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"Present Modal View");
    }];
}

- (void)startToMove{
    if ([self.actInd isAnimating]){
        [self.actInd setHidden:FALSE];
        [self.actInd stopAnimating];
        self.actInd.hidesWhenStopped = YES;
    }
    else{
        [self.actInd startAnimating];
    }
    [self.view addSubview:self.actInd];
}

- (void)setHidden{
    [self.actInd setHidden:TRUE];
}

- (IBAction)onRefresh:(id)sender {
    [self startToMove];
    [self getMessage];
}
@end
