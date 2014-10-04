//
//  SBMAReplanViewController.h
//  SBMA
//
//  Created by gb on 14-7-25.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAReplanViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *userString;
@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
- (IBAction)onRefresh:(id)sender;

@end
