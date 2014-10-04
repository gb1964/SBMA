//
//  SBMAViewController.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SBMAViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager* locationManager;
}

@property (strong, nonatomic)    CLLocationManager* locationManager;

@property (strong, nonatomic) IBOutlet UITextField *user;
@property (strong, nonatomic) IBOutlet UITextField *passwd;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

- (void)findPosition;
- (void)startToMove;
- (void)setHidden;
- (IBAction)onLogin:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *onSet;

@end
