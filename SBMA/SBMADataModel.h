//
//  SBMADataModel.h
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+Message.h"
#import "NSString+URLEncoding.h"

#define SBMASERVICENAME   @"DarewaySBMA"
#define SBMANETWORK       @"211.87.227.93"
//#define SBMANETWORK       @"221.2.204.104"
#define SBMAPORT          @"6060"
//#define SBMAPORT          @"8081"
#define SBMAPATH          @"SBM/REST"

@interface SBMSet : NSObject

@property (nonatomic, strong)NSString *network;
@property (nonatomic, strong)NSString *port;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic, strong)NSString *access_token;

@property (nonatomic, retain)NSString *cjdh;
@property (nonatomic, retain)NSString *role;

+ (NSMutableString *) produceURLString:(NSString *)cmdString;
+ (void) getRefreshToken;

@end

@interface SBMASupplierDataModel : NSObject

@property(nonatomic, strong)NSString *num;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *orderNum;

@end

@interface SBMADataModel : NSObject

@end

@interface OrderMTDataModel : NSObject

@property(nonatomic, strong)NSString *ddh;
@property(nonatomic, strong)NSString *ddscrq;
@property(nonatomic, strong)NSString *gysfk;
@property(nonatomic, strong)NSString *ddzt;
@property(nonatomic, strong)NSString *shzt;

@end

@interface OrderDetailDataModel : NSObject

@property(nonatomic, strong)NSString *ddh;
@property(nonatomic, strong)NSString *sjrcz;
@property(nonatomic, strong)NSString *sjr;
@property(nonatomic, strong)NSString *fjr;
@property(nonatomic, strong)NSString *fjrcz;
@property(nonatomic, strong)NSString *fjrdh;
@property(nonatomic, strong)NSString *sjrdh;

@property (strong, nonatomic) NSMutableArray *adata;

@end

@interface OrderData_Data : NSObject

@property(nonatomic, strong)NSString *sl;
@property(nonatomic, strong)NSString *wlzt;
@property(nonatomic, strong)NSString *wlh;
@property(nonatomic, strong)NSString *wlmc;
@property(nonatomic, strong)NSString *hh;
@property(nonatomic, strong)NSString *gddhrq;

@end

@interface ReplanDataModel : NSObject

@property(nonatomic, strong)NSString *sl;
@property(nonatomic, strong)NSString *zjhqrsj;
@property(nonatomic, strong)NSString *wlh;
@property(nonatomic, strong)NSString *wlmc;
@property(nonatomic, strong)NSString *hh;
@property(nonatomic, strong)NSString *ddh;
@property(nonatomic, strong)NSString *dddw;
@property(nonatomic, strong)NSString *zjh;
@property(nonatomic, strong)NSString *gddhrq;
@property(nonatomic, strong)NSString *ddscrq;

@end

@interface UserMessageModel : NSObject

@property(nonatomic, strong)NSString *message;
@property(nonatomic, strong)NSString *message_reason;
@property(nonatomic, strong)NSString *send_time;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *message_status;
@property(nonatomic, strong)NSString *message_from_status;

@end

@interface SBMMessageModel : NSObject

@property(nonatomic, strong)NSString *message;
@property(nonatomic, strong)NSString *message_reason;
@property(nonatomic, strong)NSString *send_time;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *message_status;
@property(nonatomic, strong)NSString *message_from_status;

@end

