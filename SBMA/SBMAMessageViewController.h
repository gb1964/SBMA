//
//  SBMAMessageViewController.h
//  SBMA
//
//  Created by gb on 14-7-10.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAMessageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *userdata;
@property (strong, nonatomic) NSMutableArray *sbmdata;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
- (IBAction)onRefresh:(id)sender;

@end
