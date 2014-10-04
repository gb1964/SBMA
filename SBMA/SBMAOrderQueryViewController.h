//
//  SBMAOrderQueryViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAOrderQueryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *orderText;

- (IBAction)onSearch:(id)sender;

@end
