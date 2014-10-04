//
//  SBMASetViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMASetViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *network;
@property (strong, nonatomic) IBOutlet UITextField *port;
@property (strong, nonatomic) IBOutlet UITextField *path;

- (IBAction)onOK:(id)sender;
- (IBAction)onBack:(id)sender;

@end
