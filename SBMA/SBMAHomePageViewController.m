//
//  SBMAHomePageViewController.m
//  SBMA
//
//  Created by gb on 14-6-22.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAHomePageViewController.h"

@interface SBMAHomePageViewController ()

@end

@implementation SBMAHomePageViewController

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
    [_webView setDelegate:self];
    // Do any additional setup after loading the view.
    [self startToMove];
    [self loadWebPageWithString:@"http://221.2.204.104"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始加载的时候执行该方法。
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

//加载完成的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self startToMove];
}

//加载出错的时候执行该方法。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
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
