//
//  SBMAInAPPViewController.h
//  SBMA
//
//  Created by gb on 14-6-27.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface SBMAInAPPViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//点击刷新按钮
- (IBAction)request:(id)sender;
//点击恢复按钮
- (IBAction)restore:(id)sender;

//刷新按钮属性
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
//恢复按钮属性
@property (weak, nonatomic) IBOutlet UIBarButtonItem *restoreButton;

//产品列表
@property (nonatomic,strong) NSArray* skProducts;
//数字格式
@property (nonatomic,strong) NSNumberFormatter * priceFormatter;
//产品标识集合
@property (nonatomic,strong) NSSet * productIdentifiers;

@end
