//
//  SBMAHomePageViewController.h
//  SBMA
//
//  Created by gb on 14-6-22.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAHomePageViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)onBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

- (void)loadWebPageWithString:(NSString*)urlString;

@end
