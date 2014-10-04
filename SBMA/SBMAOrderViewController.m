//
//  SBMAOrderViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAOrderViewController.h"
#import "SBMADataModel.h"
#import "SBMAOrderDetailViewController.h"
#import "SBJSON.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface SBMAOrderViewController ()

@end

@implementation SBMAOrderViewController

@synthesize tableView = _tableView;

@synthesize dataDisp = _dataDisp;

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
    _zt = @"";
    [self startToMove];
    [self getOrderInFO];
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
    [self getOrderInFO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//pragma mark - 实现表视图数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return _dataDisp.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cellId_Order";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    OrderMTDataModel *model = _dataDisp[indexPath.row];
    
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"订单号："];
    [str appendString:model.ddh];
    [str appendString:@"   "];
    [str appendString:_supplierString];
    [str appendString:@"                     "];
    [str appendString:@"生成日期："];
    [str appendString:model.ddscrq];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.textLabel setNumberOfLines:2];
    cell.textLabel.text = str;
    NSMutableString *subtitlestr = [[NSMutableString alloc]initWithString:@"     "];
    if ([model.gysfk isEqualToString:@"未确认"]) {
        [subtitlestr appendString:@"     "];
    }
    else
        [subtitlestr appendString:@"   "];
    [subtitlestr appendString:model.gysfk];
    [subtitlestr appendString:@"     "];
    [subtitlestr appendString:model.ddzt];
    [subtitlestr appendString:@"     "];
    [subtitlestr appendString:model.shzt];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor blueColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = subtitlestr;
    return cell;
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

- (void) getOrderInFO{
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] == NotReachable) {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"警告：网络不通！"message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [unavailAlert show];
        [self startToMove];
        return;
    }
    NSString *str = [SBMSet produceURLString:@"order/orderinquiry"];
    NSMutableString *strURL = [[NSMutableString alloc] initWithString:str];

    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSData *envelope = [strURL dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    //设置POST方法
    [request setHTTPMethod:@"POST"];
 
    //设置请求头，Content-Type字段
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [request setValue:access_token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    
    NSString *httpBodyString = [[NSString alloc] initWithFormat:@"gysdh=%@&cgzid=%@", _supplierString, _userString];
    
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置请求头，Content-Length字段
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];

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
         [self getOrderInFO];
         return;
     }];
    [operation start];
}

-(void)parserResponseData:(NSData*)datas error:(NSError *) err
{
    NSString *responseString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
    SBJSON *json = [[SBJSON alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDic = [json objectWithString:responseString error:&error];
    NSArray *array = [jsonDic objectForKey:@"ddxx"];
    if (array.count !=0)
    {
        _data = [NSMutableArray array];
        for (NSDictionary *subjson in array)
        {
            OrderMTDataModel *model = [[OrderMTDataModel alloc] init];
            model.ddh = [subjson objectForKey:@"ddh"];
            model.ddzt = [subjson objectForKey:@"ddzt"];
            model.shzt = [subjson objectForKey:@"shzt"];
            model.gysfk = [subjson objectForKey:@"gysfk"];
            model.ddscrq = [subjson objectForKey:@"ddscrq"];
            [_data addObject:model];
        }
        [self prepareDispData];
        [self computDisplayMsg];
        [self.tableView reloadData];
    }
    else
    {
        NSDictionary *subjson = [jsonDic objectForKey:@"meta"];
        NSString *message = [subjson objectForKeyedSubscript:@"message"];
        NSString *status = [subjson objectForKeyedSubscript:@"mstatus"];
        if ([message isEqualToString:@"The token have no authorization"] && [status isEqualToString:@"2"]){
            [SBMSet getRefreshToken];
            [self getOrderInFO];
        }
        else{
            [self showAlert:@"查询结果为空！" andmsg:nil];
        }
    }
    [self startToMove];
    return;
}

- (void) dimissAlert:(UIAlertView *)alert {
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void)showAlert:(NSString *)title andmsg:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0];
}

-  (void)prepareDispData{
    _dataDisp = [NSMutableArray array];
    for (int i = 0 ; i < _data.count; i++)
    {
        OrderMTDataModel *model = _data[i];
        if ([_zt isEqualToString:@""])
        {
            [_dataDisp addObject:model];
            continue;
        }
        if ([_zt isEqualToString:@"未确认"] && [model.gysfk isEqualToString:@"未确认"]){
            [_dataDisp addObject:model];
        }
        if ([_zt isEqualToString:@"未发货"] && [model.ddzt isEqualToString:@"未发货"]){
            [_dataDisp addObject:model];
            continue;
        }
        if ([_zt isEqualToString:@"未完成"]){
            [_dataDisp addObject:model];
            continue;
        }
        else if ([_zt isEqualToString:@"当天"]){
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyyMMdd"];
            NSString *strDate = [df stringFromDate:[NSDate date]];
            if ([strDate isEqualToString:model.ddscrq])
                [_dataDisp addObject:model];
            continue;
        }
        else if ([_zt isEqualToString:@"三天以内"]){
            NSString *str = model.ddscrq;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyyMMdd"];
            NSDate *compareDate = [df dateFromString:str];
            
            NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
            timeInterval = -timeInterval;
            long temp = timeInterval/(60*60*24);
            if (temp < 3)
                [_dataDisp addObject:model];
            continue;
        }
        else if ([_zt isEqualToString:@"一周以内"]){
            NSString *str = model.ddscrq;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyyMMdd"];
            NSDate *compareDate = [df dateFromString:str];
            
            NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
            timeInterval = -timeInterval;
            long temp = timeInterval/(60*60*24);
            if (temp < 7)
                [_dataDisp addObject:model];
            continue;
        }
    }
}

- (void)computDisplayMsg{
    
    int msg1, msg2, msg3;
    msg1 = msg2 = msg3 = 0;
    for (int i = 0; i < _data.count; i++)
    {
        OrderMTDataModel *model = _data[i];
        if ([model.gysfk isEqualToString:@"未确认"]){
            msg1++;
        }
        if ([model.ddzt isEqualToString:@"未发货"]){
            msg2++;
            continue;
        }
    }
    msg3 = msg2;
    NSString *str1 = [[NSString alloc]initWithFormat:@"%d", msg1];
    _msgLab1.textColor = [UIColor redColor];
    _msgLab1.text = str1;
    NSString *str2 = [[NSString alloc]initWithFormat:@"%d", msg2];
    _msgLab2.textColor = [UIColor redColor];
    _msgLab2.text = str2;
    NSString *str3 = [[NSString alloc]initWithFormat:@"%d", msg3];
    _msgLab3.textColor = [UIColor redColor];
    _msgLab3.text = str3;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SBMAOrderDetailViewController *viewController = segue.destinationViewController;
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    
    OrderMTDataModel *model = _data[selectedIndex];
    viewController.orderString = model.ddh;
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (IBAction)onDone1:(id)sender {
    if (![_zt isEqualToString:@"未确认"])
    {
        _zt = @"未确认";
        [self prepareDispData];
        [self.tableView reloadData];
    }
}

- (IBAction)onDone2:(id)sender {
    if (![_zt isEqualToString:@"未发货"])
    {
        _zt = @"未发货";
        [self prepareDispData];
        [self.tableView reloadData];
    }
}

- (IBAction)onDone3:(id)sender {
    if (![_zt isEqualToString:@"未完成"])
    {
        _zt = @"未完成";
        [self prepareDispData];
        [self.tableView reloadData];
    }
}

- (IBAction)onDone4:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"当天", @"三天以内", @"一周以内", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _zt = @"当天";
        [self prepareDispData];
        [self.tableView reloadData];
        return;
    }else if (buttonIndex == 1) {
        _zt = @"三天以内";
        [self prepareDispData];
        [self.tableView reloadData];
        return;
    }
    else if (buttonIndex == 2) {
        _zt = @"一周以内";
        [self prepareDispData];
        [self.tableView reloadData];
        return;
    }
    else{
        _zt = @"";
        [self prepareDispData];
        [self.tableView reloadData];
        return;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onRefresh:(id)sender {
    _zt = @"";
    [self startToMove];
    [self getOrderInFO];
}

@end
