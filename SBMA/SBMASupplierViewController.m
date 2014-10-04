//
//  SBMASupplierViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMASupplierViewController.h"
#import "SBMAOrderViewController.h"
#import "SSKeychain.h"
#import "SBJSON.h"
#import "SBMADataModel.h"
#import "Reachability.h"
#import "AFNetworking.h"

#define ITEM_HEIGHT 50

@interface SBMASupplierViewController ()

@end

@implementation SBMASupplierViewController

@synthesize tableView = _tableView;

//@synthesize refreshing;
//@synthesize page;
@synthesize data = _data;

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
    _data = nil;
    [self startToMove];
    [self getSupplierList];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

/*
- (void) refresh:(NSNotification*) notification{
    UIViewController *viewController = [notification object];
    if (viewController == self){
        [self startToMove];
        [self getSupplierList];
    }
}
 */
- (void) refresh{
    [self startToMove];
    [self getSupplierList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getSupplierList{
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] == NotReachable) {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"警告：网络不通！"message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [unavailAlert show];
        [self startToMove];
        return;
    }
    
    NSArray *temp = [[SSKeychain accountsForService:SBMASERVICENAME]lastObject];
    _userString= [temp valueForKey:@"acct"];
    
    NSString *str = [SBMSet produceURLString:@"user/supplierlist"];
    
    NSMutableString *strURL = [[NSMutableString alloc] initWithCapacity:100];
    
    [strURL setString:str];
    [strURL appendString:@"?"];
    [strURL appendString:@"username="];
    [strURL appendString:_userString];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    NSData *envelope = [strURL dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置POST方法
	[request setHTTPMethod:@"GET"];
    
    //设置请求头，Content-Type字段
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [request setValue:access_token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];

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
         [self startToMove];
         [self getSupplierList];
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
    NSArray *array = [jsonDic objectForKey:@"enterprise"];
    if (array.count !=0)
    {
        _data = [NSMutableArray array];
        for (NSDictionary *subjson in array)
        {
            SBMASupplierDataModel *model = [[SBMASupplierDataModel alloc] init];
            model.num = [subjson objectForKey:@"gysdh"];
            model.name = [subjson objectForKey:@"cjmc"];
            model.orderNum = [subjson objectForKey:@"len"];
            if ([model.orderNum isEqualToString:nil])
                model.orderNum = @"0";
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
            [self getSupplierList];
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
}

- (void)showAlert:(NSString *)title andmsg:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0];
}

#pragma mark - 实现表视图数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId_Supplier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    SBMASupplierDataModel *model = _data[indexPath.row];
    NSMutableString *str = [[NSMutableString alloc]initWithString:model.name];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.highlightedTextColor = [UIColor blueColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setNumberOfLines:1];
    cell.textLabel.text = str;
    NSString *subtitlestr = [[NSString alloc]initWithString:model.orderNum];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor redColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    [cell.detailTextLabel setNumberOfLines:1];
    cell.detailTextLabel.text = subtitlestr;
    return cell;
}

#pragma mark - PullingRefreshTableViewDelegate
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SBMAOrderViewController *viewController = segue.destinationViewController;
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    
    SBMASupplierDataModel *model = _data[selectedIndex];
    viewController.supplierString = model.num;
    viewController.userString = _userString;
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
    [self getSupplierList];
}
@end
