//
//  SBMAMyViewController.m
//  SBMA
//
//  Created by gb on 14-6-23.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAMyViewController.h"

@interface SBMAMyViewController ()

//@property (nonatomic,strong) LXActionSheet *actionSheet;

@end

@implementation SBMAMyViewController

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
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现表视图数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId_MySBMA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row)
    {
        case 0 :
            cell.textLabel.text = @"设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
 //           cell.textLabel.text = @"应用内购买";
            cell.textLabel.text = @"我的信息";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = @"关于SBMA";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 3:
            cell.textLabel.text = @"联系我们";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 4:
            cell.textLabel.text = @"";
            break;
        case 5:
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.0];
            cell.textLabel.text = @"退出登录";
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    UIActionSheet *actionSheet;
    switch (indexPath.row)
    {
        case 0 :
            [self presentNextViewController:@"SBMASetView"];
            break;
        case 1 :
     //       [self presentNextViewController:@"SBMAInAPPView"];
            [self presentNextViewController:@"SBMAMyInfoView"];
            break;
        case 2:
            [self presentNextViewController:@"SBMAHomePageView"];
            break;
        case 3:
            [self presentNextViewController:@"SBMAContractusView"];
            break;
        case 5:
            actionSheet = [[UIActionSheet alloc]
                                initWithTitle:@"退出后不会删除任何历史数据,下次登录依然可以使用本账号"
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:@"退出登录"
                                otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
            break;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        return;
    }else if (buttonIndex == 1) {
        return;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
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

- (void)presentNextViewController:(NSString *)identifier{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"Present Modal View");
    }];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
/*
- (IBAction)onExit:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"退出后不会删除任何历史数据,下次登录依然可以使用本账号"
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:@"退出登录"
                   otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
 */
@end
