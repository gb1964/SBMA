//
//  SBMAOrderDetailViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAOrderDetailViewController.h"
#import "SBMADataModel.h"
#import "SBMAOrderDetailWLViewController.h"
#import "SBJSON.h"
#import "AFNetworking.h"

@interface SBMAOrderDetailViewController ()

@end

@implementation SBMAOrderDetailViewController

@synthesize ODDdata = _ODDdata;
@synthesize orderString = _orderString;

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
    [self getOrderDetail];
}

- (void)setHidden:(BOOL)bBOOL{
    [self.titleLabel setHidden:bBOOL];
    [self.subtitleLabel setHidden:bBOOL];
    [self.sLabel setHidden:bBOOL];
    [self.cLabel setHidden:bBOOL];
    [self.senderLabel setHidden:bBOOL];
    [self.receiverLabel setHidden:bBOOL];
}

- (void) updateMyLabel{
    [self setHidden:FALSE];
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"采购订单号："];
    [str appendString:_orderString];
    _titleLabel.text = str;

    NSMutableString *str1 = [[NSMutableString alloc]initWithString:@"      "];
    [str1 appendString:_ODDdata.sjr];
    [str1 appendString:@"    "];
    [str1 appendString:_ODDdata.sjrdh];
    _receiverLabel.font = [UIFont systemFontOfSize:14];
    _receiverLabel.textColor = [UIColor blueColor];
    _receiverLabel.text = str1;
    
    NSMutableString *str2 = [[NSMutableString alloc]initWithString:@"      "];
    [str1 appendString:_ODDdata.fjr];
    [str2 appendString:@"    "];
    [str2 appendString:_ODDdata.fjrdh];
    _senderLabel.font = [UIFont systemFontOfSize:14];
    _senderLabel.textColor = [UIColor blueColor];
    _senderLabel.text = str2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现表视图数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ODDdata.adata.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId_OrderListDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    OrderData_Data *model = _ODDdata.adata[indexPath.row];
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"行号："];
    [str appendString:model.hh];
    [str appendString:@"   "];
 //   [str appendString:@"物料状态："];
 //   [str appendString:model.wlzt];
    [str appendString:@"   "];
    [str appendString:@"物料号："];
    [str appendString:model.wlh];
    [str appendString:@"                   到货日期："];
    [str appendString:model.gddhrq];
    [str appendString:@"  订单数量："];
    [str appendString:model.sl];
    [str appendString:@"                                      "];
    [str appendString:@"物料描述："];
    [str appendString:model.wlmc];
    
    
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.highlightedTextColor = [UIColor blueColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.textLabel setNumberOfLines:4];
    cell.textLabel.text = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
     //选择表视图行时候触发
     [self performSegueWithIdentifier:@"OrderDetailWL" sender:self];
}

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

- (void) getOrderDetail{
    NSString *str = [SBMSet produceURLString:@"orderdetail/detail"];
    
    NSMutableString *strURL = [[NSMutableString alloc] initWithCapacity:100];
    
    [strURL setString:str];
    [strURL appendString:@"?"];
    [strURL appendString:@"ddh="];
    [strURL appendFormat:@"%@",_orderString];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSData *envelope = [strURL dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置GET方法
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
    NSDictionary *jsonsub = [jsonDic objectForKey:@"ddtt"];
    if (jsonsub.count !=0)
    {
        _ODDdata = [[OrderDetailDataModel alloc] init];
        _ODDdata.fjrdh = [jsonsub objectForKey:@"fjrdh"];
        _ODDdata.sjrdh = [jsonsub objectForKey:@"sjrdh"];
        _ODDdata.sjr = [jsonsub objectForKey:@"sjr"];
        _ODDdata.ddh = [jsonsub objectForKey:@"ddh"];
        _ODDdata.fjr = [jsonsub objectForKey:@"fjr"];
        _ODDdata.adata = [NSMutableArray array];
        NSArray *array = [jsonDic objectForKey:@"wlxx"];
        for (NSDictionary *subjson in array)
        {
            OrderData_Data *model = [[OrderData_Data alloc] init];
            model.sl = [subjson objectForKey:@"sl"];
            model.wlzt = [subjson objectForKey:@"wlzt"];
            model.wlh = [subjson objectForKey:@"wlh"];
            model.wlmc = [subjson objectForKey:@"wlmc"];
            model.hh = [subjson objectForKey:@"hh"];
            model.gddhrq = [subjson objectForKey:@"gddhrq"];
            [_ODDdata.adata addObject:model];
        }
        [self updateMyLabel];
        [self.tableView reloadData];
    }
    else
    {
        NSDictionary *subjson = [jsonDic objectForKey:@"meta"];
        NSString *message = [subjson objectForKeyedSubscript:@"message"];
        NSString *status = [subjson objectForKeyedSubscript:@"mstatus"];
        if ([message isEqualToString:@"The token have no authorization"] && [status isEqualToString:@"2"]){
            [SBMSet getRefreshToken];
            [self getOrderDetail];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SBMAOrderDetailWLViewController *viewController = segue.destinationViewController;
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    
    viewController.ddh_str = _orderString;
    OrderData_Data *model = _ODDdata.adata[selectedIndex];
    viewController.hh_str = model.hh;
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

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
