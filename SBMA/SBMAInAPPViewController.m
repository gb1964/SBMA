//
//  SBMAInAPPViewController.m
//  SBMA
//
//  Created by gb on 14-6-27.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAInAPPViewController.h"

@interface SBMAInAPPViewController ()

@end

@implementation SBMAInAPPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    //设置数字格式
    self.priceFormatter = [[NSNumberFormatter alloc] init];
    [self.priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [self.priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    //从ProductIdentifiers.plist文件读取应用内产品标识
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ProductIdentifiers" ofType:@"plist"];
    NSArray* array = [[NSArray alloc] initWithContentsOfFile:path];
    //从NSArray转化为NSSet
    self.productIdentifiers = [[NSSet alloc] initWithArray:array];
    
    // 添加self作为交易观察者对象
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SKProductsRequestDelegate协议实现方法
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"加载应用内购买产品...");
    
    self.navigationItem.prompt = nil;
    self.refreshButton.enabled = YES;
    self.restoreButton.enabled = YES;
    
    self.skProducts = response.products;
    for (SKProduct * skProduct in self.skProducts) {
        NSLog(@"找到产品: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    [_tableView reloadData];
}

#pragma mark---UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.skProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
/*
    static NSString *CellIdentifier = @"cellId_InAPP";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
 
    int row = [IndexPath row];
    SKProduct * product = self.skProducts[row];
    
	cell.textLabel.text = product.localizedTitle;
    
    [self.priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [self.priceFormatter stringFromNumber:product.price];
    
    //从应用设置文件中读取 购买信息
    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
    if (productPurchased) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        UIImage *buttonUpImage = [UIImage imageNamed:@"button_up.png"];
		UIImage *buttonDownImage = [UIImage imageNamed:@"button_down.png"];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0.0f, 0.0f, buttonUpImage.size.width, buttonUpImage.size.height);
		[button setBackgroundImage:buttonUpImage forState:UIControlStateNormal];
		[button setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
		[button setTitle:@"购买" forState:UIControlStateNormal];
        button.tag = indexPath.row;
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
		
		cell.accessoryView = button;
        
    }
    return cell;
*/
    return nil;
}
#pragma mark SKPaymentTransactionObserver协议实现方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased: //交易完成
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:    //交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:  //交易恢复
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
    
}

//交易完成
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"交易完成...");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    //把交易从付款队列中移除
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//交易恢复
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"交易恢复...");
    
    self.navigationItem.prompt = nil;
    self.refreshButton.enabled = YES;
    self.restoreButton.enabled = YES;
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"交易失败...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"交易失败: %@", transaction.error.localizedDescription);
        switch (transaction.error.code) {
                
            case SKErrorUnknown:
                
                NSLog(@"SKErrorUnknown");
                
                break;
                
            case SKErrorClientInvalid:
                
                NSLog(@"SKErrorClientInvalid");
                
                break;
                
            case SKErrorPaymentCancelled:
                
                NSLog(@"SKErrorPaymentCancelled");
                
                break;
                
            case SKErrorPaymentInvalid:
                
                NSLog(@"SKErrorPaymentInvalid");
                
                break;
                
            case SKErrorPaymentNotAllowed:
                
                NSLog(@"SKErrorPaymentNotAllowed");
                
                break;
                
            default:
                
                NSLog(@"No Match Found for error");
                
                break;
                
        }
        
        NSLog(@"transaction.error.code %@",[transaction.error description]);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//购买成功
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)buttonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    //通过按钮tag获得被点击按钮的索引，使用索引从数组中取出产品SKProduct对象
    SKProduct *product = self.skProducts[buyButton.tag];
    //获得产品的付款对象
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    //把付款对象添加到付款队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (IBAction)request:(id)sender {
    
    //检查设备是否有家长控制，禁止应用内购买
    if ([SKPaymentQueue canMakePayments]) {
        //没有设置可以请求应用购买信息
        SKProductsRequest *request= [[SKProductsRequest alloc]
                                     initWithProductIdentifiers:self.productIdentifiers];
        request.delegate = self;
        [request start];
        
        self.navigationItem.prompt = @"刷新中...";
        self.refreshButton.enabled = NO;
        self.restoreButton.enabled = NO;
        
    } else {
        //有设置情况下
        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"访问限制"
                                                             message:@"您不能进行应用内购买！"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        [alertView show];
    }
}

- (IBAction)restore:(id)sender {
    self.navigationItem.prompt = @"恢复中...";
    self.refreshButton.enabled = NO;
    self.restoreButton.enabled = NO;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
