//
//  SBMASupplierViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface SBMASupplierViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
//    int maxPage;
//}

@interface SBMASupplierViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> 
/*
@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;
@property (retain,nonatomic) NSMutableArray *list;
*/
@property (strong, nonatomic) IBOutlet UITableView *tableView;
    
@property (strong, nonatomic) NSString *userString;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
- (IBAction)onRefresh:(id)sender;

@end

