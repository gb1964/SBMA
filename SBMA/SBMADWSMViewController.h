//
//  SBMADWSMViewController.h
//  SBMA
//
//  Created by gb on 14-6-22.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMADWSMViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)onBack:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
