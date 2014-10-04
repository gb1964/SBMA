//
//  SBMAOrderViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAOrderViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString *zt;

@property (strong, nonatomic) NSString *supplierString;
@property (strong, nonatomic) NSString *userString;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *dataDisp;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UILabel *msgLab1;
@property (strong, nonatomic) IBOutlet UILabel *msgLab2;
@property (strong, nonatomic) IBOutlet UILabel *msgLab3;

- (IBAction)onDone1:(id)sender;
- (IBAction)onDone2:(id)sender;
- (IBAction)onDone3:(id)sender;
- (IBAction)onDone4:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onRefresh:(id)sender;

@end
