//
//  SBMAMMViewController.h
//  SBMA
//
//  Created by gb on 14-7-11.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAMMViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString    *titleString;
@property (strong, nonatomic) IBOutlet UINavigationBar *titleBar;

@property (strong, nonatomic) IBOutlet UILabel *message_title;
@property (strong, nonatomic) IBOutlet UILabel *message_status;
@property (strong, nonatomic) IBOutlet UILabel *message_from_status;

@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UITextView *message_reason;
@property (strong, nonatomic) IBOutlet UIButton *btnLast;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)onBack:(id)sender;
- (IBAction)onLast:(id)sender;
- (IBAction)onNext:(id)sender;

@end
