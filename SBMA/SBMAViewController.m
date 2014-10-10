//
//  SBMAViewController.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAViewController.h"
#import "SSKeychain.h"
#import "SBMAHomeViewController.h"
#import "SBJSON.h"
#import "SBMADataModel.h"
#import "SBMALog.h"
#import "Reachability.h"
#import "AFNetworking.h"

//
//  SBMAViewController.m
//  SBMA
//
//  Created by gb on 14-6-8.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

@implementation SBMAViewController

@synthesize user = _user;
@synthesize passwd = _passwd;
@synthesize locationManager;

int action;
NSMutableString *requestString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:SBMANETWORK forKey:@"network"];
    [[NSUserDefaults standardUserDefaults] setObject:SBMAPORT forKey:@"port"];
    [[NSUserDefaults standardUserDefaults] setObject:SBMAPATH forKey:@"path"];

    [self setHidden];    
//    _btnLogin.enabled = YES;
    
    NSArray *temp = [[SSKeychain accountsForService:SBMASERVICENAME]lastObject];
    _user.text = [temp valueForKey:@"acct"];
    _passwd.text = [SSKeychain passwordForService:SBMASERVICENAME account:_user.text];
//    [self findPosition];
    [self startToMove];
    [self startLogin];
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
    if ([_user isFirstResponder] && [touch view] != _user)
    {
        [_user resignFirstResponder];
    }
    else if ([_passwd isFirstResponder] && [touch view] != _passwd)
    {
        [_passwd resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void) startLogin{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] == NotReachable) {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"警告：网络不通！"message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [unavailAlert show];
        [self startToMove];
        return;
    }

    NSMutableString *stringURL = [[NSMutableString alloc] initWithCapacity:100];
    [stringURL setString:@"http://"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"network"];
    [stringURL appendString:network];
    [stringURL appendString:@":"];
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    [stringURL appendString:port];
    [stringURL appendString:@"/SBM/REST/loginimpl/logintest"];
    
    NSURL *url = [NSURL URLWithString:[stringURL URLEncodedString]];
    
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求头，Content-Type字段
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Basic c2JtX3Jlc3Q6c2R1YXNw" forHTTPHeaderField:@"Authorization"];
//    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    
    NSString *httpBodyString = [[NSString alloc] initWithFormat:@"username=%@&password=%@", _user.text, _passwd.text];
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置POST方法
	[request setHTTPMethod:@"POST"];
    
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
    NSString *str = [jsonDic objectForKey:@"flag"];
    if ([str isEqualToString:@"success"]){
        NSDictionary *subjson = [jsonDic objectForKey:@"meta"];
        NSString *refresh_token_str = [subjson objectForKey:@"refresh_token"];
        [[NSUserDefaults standardUserDefaults] setObject:refresh_token_str forKey:@"refresh_token"];
        NSString *access_token_str = [subjson objectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:access_token_str forKey:@"access_token"];
        [self startToMove];
        [self presentNextViewController];
        return;
    }
    [self showAlert:@"账号或密码错误！" andmsg:nil];
/*
    UIAlertView* alertMessage = [[UIAlertView alloc]
                                 initWithTitle:@"登录失败!!!"
                                 message:@"账号或密码错误！"
                                 delegate:nil
                                 cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    [alertMessage show];
*/
    [self startToMove];
    //    _btnLogin.enabled = YES;
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

- (void)presentNextViewController{
    [SSKeychain setPassword:_passwd.text forService:SBMASERVICENAME account:_user.text];

    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SBMAHomeViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SBMAHomeView"];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"Present Modal View");
    }];
}

- (void)startToMove{
    if ([self.actInd isAnimating]){
        [self.actInd setHidden:FALSE];
        [self.actInd stopAnimating];
    }
    else{
        [self.actInd startAnimating];
    }
    [self.view addSubview:self.actInd];
}

- (void)setHidden{
    [self.actInd setHidden:TRUE];
    self.actInd.hidesWhenStopped = YES;
}

- (IBAction)onLogin:(id)sender {
    [_user resignFirstResponder];
    [_passwd resignFirstResponder];
    
    NSString* username = _user.text;
    NSString* password = _passwd.text;
    
    if ([username length] == 0 || [password length] == 0)
    {
        [self showAlert:@"帐号或密码为空!!!" andmsg:nil];
/*
        UIAlertView* alertMessage = [[UIAlertView alloc]
                                     initWithTitle:@"登录失败!!!"
                                     message:@"帐号或密码为空!!!"
                                     delegate:nil
                                     cancelButtonTitle:@"确认"
                                     otherButtonTitles:nil];
        [alertMessage show];
*/
        return;
    }
 //   _btnLogin.enabled = NO;
    [self startToMove];
    [self startLogin];
}

- (IBAction)onSet:(id)sender {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)findPosition{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSString *latituduText = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude];
    NSString *longitudeText = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude];
    [locationManager stopUpdatingLocation];
    NSLog(@"location ok, latitude =%@ longitude = %@", latituduText, longitudeText);
}

@end

