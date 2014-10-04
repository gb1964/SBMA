//
//  SBMAReplanViewController.m
//  SBMA
//
//  Created by gb on 14-7-25.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAReplanViewController.h"
#import "SSKeychain.h"
#import "SBMADataModel.h"
#import "SBJSON.h"
#import "Reachability.h"、
#import "AFNetworking.h"

@interface SBMAReplanViewController ()

@end

@implementation SBMAReplanViewController

@synthesize tableView = _tableView;

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
    [self startToMove];
    [self getReplanInFO];
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
    [self getReplanInFO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return _data.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 120.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cellId_Replan";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    ReplanDataModel *model = _data[indexPath.row];
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"订单号："];
    [str appendString:model.ddh];
    [str appendFormat:@"    行号：%@                  ", model.hh];
    [str appendFormat:@"%@", model.wlmc];
    [str appendFormat:@" 数量：%@             ", model.sl];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.textLabel setNumberOfLines:2];
    cell.textLabel.text = str;
    
    NSMutableString *substr = [[NSMutableString alloc]initWithString:@"再计划状态："];
    [substr appendFormat:@"%@                                    ", model.zjh];
    [substr appendFormat:@"再计划时间：%@                   ", model.zjhqrsj];
    [substr appendFormat:@"生成日期：%@                                    ", model.gddhrq];
    [substr appendFormat:@"到货日期：%@", model.zjhqrsj];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor blueColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    [cell.detailTextLabel setNumberOfLines:4];
    cell.detailTextLabel.text = substr;
    return cell;
}

- (void) getReplanInFO{
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] == NotReachable) {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"警告：网络不通！"message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [unavailAlert show];
        [self startToMove];
        return;
    }
    
    NSString *strURL = [SBMSet produceURLString:@"replanconfirm/replan"];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求头，Content-Type字段
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [request setValue:access_token forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];

    NSArray *temp = [[SSKeychain accountsForService:SBMASERVICENAME]lastObject];
    NSString *userStr = [temp valueForKey:@"acct"];

    NSString *httpBodyString = [[NSString alloc] initWithFormat:@"cgzid=%@", userStr];
    
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置POST方法
	[request setHTTPMethod:@"POST"];
    
    //设置请求头，Content-Length字段
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
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
         [self getReplanInFO];
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
    NSArray *array = [jsonDic objectForKey:@"zjhorder"];
    if (array.count !=0)
    {
        _data = [NSMutableArray array];
        for (NSDictionary *subjson in array)
        {
            ReplanDataModel *model = [[ReplanDataModel alloc] init];
            model.sl = [subjson objectForKey:@"sl"];
            model.wlh = [subjson objectForKey:@"wlh"];
            model.dddw = [subjson objectForKey:@"dddw"];
            model.wlmc = [subjson objectForKey:@"wlmc"];
            model.zjhqrsj = [subjson objectForKey:@"zjhqrsj"];
            model.ddh = [subjson objectForKey:@"ddh"];
            model.zjh = [subjson objectForKey:@"zjh"];
            model.hh = [subjson objectForKey:@"hh"];
            model.gddhrq = [subjson objectForKey:@"gddhrq"];
            model.ddscrq = [subjson objectForKey:@"ddscrq"];
            [_data addObject:model];
        }
        [self.tableView reloadData];
    }
    else
    {
        NSDictionary *subjson = [jsonDic objectForKey:@"meta"];
        NSString *message = [subjson objectForKeyedSubscript:@"message"];
        NSString *status = [subjson objectForKeyedSubscript:@"mstatus"];
        if ([message isEqualToString:@"The token have no authorization"] && [status isEqualToString:@"2"]){
            [SBMSet getRefreshToken];
            [self getReplanInFO];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [self getReplanInFO];
}
@end
