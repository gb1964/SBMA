//
//  SBMAOrderDetailWLViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAOrderDetailWLViewController.h"
#import "SBJSON.h"
#import "SBMADataModel.h"
#import "AFNetworking.h"

@interface SBMAOrderDetailWLViewController ()

@end

@implementation SBMAOrderDetailWLViewController

@synthesize ddh_str = _ddh_str;
@synthesize hh_str = _hh_str;

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
    [self startToMove];
    [self getOrderWLDetail];
    
    _items = @[@"订单号：", @"行号：", @"物料号：",  @"物料状态：", @"物料名称：", @"单位：", @"库存：", @"数量：", @"收货数量：", @"已发货数量：", @"退货数量：", @"到货日期：", @"end"];
    _labelArray = [NSMutableArray array];
    _strArray = [NSMutableArray array];
    UILabel *lab1, *lab2;
    for(int i = 0; i < _items.count - 1; i++)
    {
        lab1 = [[UILabel alloc] initWithFrame:CGRectZero];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:lab1];
        [_labelArray addObject:lab1];
        
        lab2 = [[UILabel alloc] initWithFrame:CGRectZero];
        lab2.font = [UIFont systemFontOfSize:14];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = [UIColor blueColor];
        [self.view addSubview:lab2];
        [_strArray addObject:lab2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateMyLabel{
    UILabel *lab1, *lab2;
    
    for (int i = 0; i < _items.count - 1; i++)
    {
        lab1 = _labelArray[i];
        lab1.frame = CGRectMake(5, 80+i*25, 100, 25);
        lab1.text = [NSString stringWithFormat:@"%@", _items[i]];
        
        lab2 = _strArray[i];
        lab2.frame = CGRectMake(105, 80+i*25, 200, 25);
        lab2.text = [NSString stringWithFormat:@"%@", _data[i]];
    }
}

- (void) getOrderWLDetail{
    NSString *str = [SBMSet produceURLString:@"orderwldetail/wldetail"];
    
    NSMutableString *strURL = [[NSMutableString alloc] initWithCapacity:100];
    
    [strURL setString:str];
    [strURL appendString:@"?"];
    [strURL appendString:@"ddh="];
    [strURL appendFormat:@"%@",_ddh_str];
    [strURL appendString:@"&"];
    [strURL appendString:@"hh="];
    [strURL appendFormat:@"%@",_hh_str];
    
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
    NSDictionary *subjson = [jsonDic objectForKey:@"wlxx"];
    if (subjson.count !=0)
    {
        _data = [NSMutableArray array];
        [_data addObject:[subjson objectForKey:@"ddh"]];
        [_data addObject:[subjson objectForKey:@"hh"]];
        [_data addObject:[subjson objectForKey:@"wlh"]];
        [_data addObject:[subjson objectForKey:@"wlzt"]];
        [_data addObject:[subjson objectForKey:@"wlmc"]];
        [_data addObject:[subjson objectForKey:@"dddw"]];
        [_data addObject:[subjson objectForKey:@"kc"]];
        [_data addObject:[subjson objectForKey:@"sl"]];
        [_data addObject:[subjson objectForKey:@"shsl"]];
        [_data addObject:[subjson objectForKey:@"yfhsl"]];
        [_data addObject:[subjson objectForKey:@"thsl"]];
        [_data addObject:[subjson objectForKey:@"gddhrq"]];
        [_data addObject:@"end"];
        [self updateMyLabel];
    }
    else
    {
        NSDictionary *subjson = [jsonDic objectForKey:@"meta"];
        NSString *message = [subjson objectForKeyedSubscript:@"message"];
        NSString *status = [subjson objectForKeyedSubscript:@"mstatus"];
        if ([message isEqualToString:@"The token have no authorization"] && [status isEqualToString:@"2"]){
            [SBMSet getRefreshToken];
            [self getOrderWLDetail];
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

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
