//
//  SBMAMMViewController.m
//  SBMA
//
//  Created by gb on 14-7-11.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMAMMViewController.h"
#import "SBMADataModel.h"

@interface SBMAMMViewController ()

@end

@implementation SBMAMMViewController

@synthesize data = _data;
@synthesize titleString = _titleString;

int pos = 0;

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
    // Do any additional setup after loading the view.
    [self updateMyData];
    _btnLast.enabled = NO;
    if (_data.count <= 1){
        _btnNext.enabled = NO;
    }
}

- (void) updateMyData{
    _titleBar.topItem.title = _titleString;
    
    UserMessageModel *model = _data[pos];
    _message_title.text = model.title;
    _message_status.text = model.message_status;
    _message_from_status.text = model.message_from_status;
    
    _message.text = model.message;
    _message_reason.text = model.message_reason;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onLast:(id)sender {
    pos = pos - 1;
    if (pos == 0){
        _btnLast.enabled = NO;
        _btnNext.enabled = YES;
    }
    [self updateMyData];
}

- (IBAction)onNext:(id)sender {
    pos = pos + 1;
    if (pos == _data.count - 1){
        _btnLast.enabled = YES;
        _btnNext.enabled = NO;
    }
    [self updateMyData];
}
@end
