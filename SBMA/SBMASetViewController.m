//
//  SBMASetViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMASetViewController.h"

@interface SBMASetViewController ()

@end

@implementation SBMASetViewController

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
    
    _network.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"network"];
    _port.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    _path.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"path"];
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
    if ([_network isFirstResponder] && [touch view] != _network)
    {
        [_network resignFirstResponder];
    }
    else if ([_port isFirstResponder] && [touch view] != _port)
    {
        [_port resignFirstResponder];
    }
    else if ([_path isFirstResponder] && [touch view] != _path)
    {
        [_path resignFirstResponder];
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

- (IBAction)onOK:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:_network.text forKey:@"network"];
    [[NSUserDefaults standardUserDefaults] setObject:_port.text forKey:@"port"];
    [[NSUserDefaults standardUserDefaults] setObject:_path.text forKey:@"path"];

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
