//
//  SBMAOrderDetailWLViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMAOrderDetailWLViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *data;

@property (weak, nonatomic) NSString *ddh_str;
@property (weak, nonatomic) NSString *hh_str;

@property (strong, nonatomic) NSMutableArray *labelArray;
@property (strong, nonatomic) NSMutableArray *strArray;
@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

- (IBAction)onBack:(id)sender;

@end
