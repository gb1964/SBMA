//
//  SBMAMyInfoViewController.h
//  SBMA
//
//  Created by gb on 14-7-6.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAMyInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *qq;

- (IBAction)onBack:(id)sender;
- (IBAction)onOK:(id)sender;

@end
