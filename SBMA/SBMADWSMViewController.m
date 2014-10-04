//
//  SBMADWSMViewController.m
//  SBMA
//
//  Created by gb on 14-6-22.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMADWSMViewController.h"

@interface SBMADWSMViewController ()

@end

@implementation SBMADWSMViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现表视图数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId_MySBMA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor blueColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];

    switch (indexPath.row)
    {
        case 0 :
            cell.textLabel.text = @"地址：";
            cell.detailTextLabel.text = @"    山东省济南市高新区舜华路1500号";
            break;
        case 1:
            cell.textLabel.text = @"电话：";
            cell.detailTextLabel.text = @"    18678775115";
            break;
        case 2:
            cell.textLabel.text = @"E-mail：";
            cell.detailTextLabel.text = @"    dwsm_sbm@163.com";
            break;
        case 3:
            cell.textLabel.text = @"QQ：";
            cell.detailTextLabel.text = @"   2898213608 ";
            break;
        case 4:
            cell.textLabel.text = @"微信：";
            cell.detailTextLabel.text = @"    ";
        break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    NSMutableString *str;
//    UIWebView *callWebview;
    switch (indexPath.row)
    {
        case 0 :
            break;
        case 1 :
            
            str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"18678775115"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
  
   //         callWebview =[[UIWebView alloc]init];
            // tel:  或者 tel://
   //         NSURL *telURL =[NSURL URLWithString:@"18678775115"];
   //         [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
   //         [self.view addSubview:callWebview];

//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18678775115"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://dwsm_sbm@163.com"]];
            break;
        case 3:
            break;
        case 4:
            break;
    }
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

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
