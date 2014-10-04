//
//  SBMAMyViewController.h
//  SBMA
//
//  Created by gb on 14-6-23.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAMyViewController : UIViewController <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
