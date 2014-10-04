//
//  SBMAOrderDetailViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailDataModel;

@interface SBMAOrderDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableData *datas;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) OrderDetailDataModel *ODDdata;

@property (strong, nonatomic) NSString  *orderString;

@property (strong, nonatomic) IBOutlet UILabel *sLabel;
@property (strong, nonatomic) IBOutlet UILabel *cLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderLabel;
@property (strong, nonatomic) IBOutlet UILabel *receiverLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

- (IBAction)onBack:(id)sender;

@end
