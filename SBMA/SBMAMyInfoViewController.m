//
//  SBMAMyInfoViewController.m
//  SBMA
//
//  Created by gb on 14-7-6.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAMyInfoViewController.h"

extern NSString *CTSettingCopyMyPhoneNumber();

@interface SBMAMyInfoViewController ()

@end

@implementation SBMAMyInfoViewController

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
    
    _phoneNum.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    _email.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    _qq.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"qq"];
//    NSString *phoneStr = CTSettingCopyMyPhoneNumber();
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
    if ([_phoneNum isFirstResponder] && [touch view] != _phoneNum)
    {
        [_phoneNum resignFirstResponder];
    }
    else if ([_email isFirstResponder] && [touch view] != _email)
    {
        [_email resignFirstResponder];
    }
    else if ([_qq isFirstResponder] && [touch view] != _qq)
    {
        [_qq resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
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

- (IBAction)onOK:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:_phoneNum.text forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:_email.text forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:_qq.text forKey:@"qq"];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];}
@end
