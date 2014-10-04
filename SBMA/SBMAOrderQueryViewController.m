//
//  SBMAOrderQueryViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAOrderQueryViewController.h"
#import "SBMAOrderViewController.h"
#import "SBMAOrderDetailViewController.h"

@interface SBMAOrderQueryViewController ()

@end

@implementation SBMAOrderQueryViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([_orderText isFirstResponder] && [touch view] != _orderText)
    {
        [_orderText resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SBMAOrderDetailViewController *viewController = segue.destinationViewController;
    viewController.orderString = _orderText.text;
}

- (IBAction)onSearch:(id)sender {
    if ([_orderText.text isEqualToString:@""])
    {
/*
        UIAlertView* alertMessage = [[UIAlertView alloc]
                                     initWithTitle:@"错误"
                                     message:@"订单号为空!!!"
                                     delegate:nil
                                     cancelButtonTitle:@"确认"
                                     otherButtonTitles:nil];
        [alertMessage show];
*/
        [self showAlert:@"查询结果为空！" andmsg:nil];

    }
    else{
        [self presentOrderDetailViewController];
        return;
    }
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
- (void)presentOrderViewController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SBMAOrderViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SBMAOrderView"];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"Present Modal View");
    }];
}
*/
- (void)presentOrderDetailViewController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SBMAOrderDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SBMAOrderDetailView"];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewController.orderString = _orderText.text;
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"Present Modal View");
    }];
}

@end
