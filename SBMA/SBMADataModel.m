//
//  SBMADataModel.m
//  SBMA
//
//  Created by gb on 14-6-20.
//  Copyright (c) 2014年 sdu.edu.cn. All rights reserved.
//

#import "SBMADataModel.h"
#import "AFNetworking.h"
#import "SBJSON.h"

@implementation SBMSet

+ (SBMSet *)sharedSingleton
{
    static SBMSet *sharedSingleton=nil;//之前忘记赋值为nil,程序一直出错
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[SBMSet alloc] init];
        
        return sharedSingleton;
    }
}

+ (NSMutableString *) produceURLString:(NSString *)cmdString{
    
    NSMutableString *stringURL = [[NSMutableString alloc] initWithCapacity:100];
    [stringURL setString:@"http://"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"network"];
    [stringURL appendString:network];
    [stringURL appendString:@":"];
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    [stringURL appendString:port];
    [stringURL appendString:@"/"];
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"path"];
    [stringURL appendString:path];
    [stringURL appendString:@"/"];
    [stringURL appendString:cmdString];
    return stringURL;
}

+ (void) getRefreshToken{
    NSString *str = [SBMSet produceURLString:@"refresh/refreshtoken"];
    NSMutableString *strURL = [[NSMutableString alloc] initWithString:str];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    NSData *envelope = [strURL dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置GET方法
    [request setHTTPMethod:@"GET"];
    
    //设置请求头，Content-Type字段
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *refresh_token_str = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
    [request setValue:refresh_token_str forHTTPHeaderField:@"Authorization"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    
    //设置请求头，Content-Length字段
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSError *err;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response %@", [operation responseString]);
         [self parserResponseData:responseObject error:err];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response %@", [operation responseString]);
         NSLog(@"Error: %@", error);
     }];
    
    [operation start];
}

+ (void)parserResponseData:(NSData*)datas error:(NSError *) err
{
    NSString *responseString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
    SBJSON *json = [[SBJSON alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDic = [json objectWithString:responseString error:&error];
    NSString *refresh_token_str = [jsonDic objectForKey:@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] setObject:refresh_token_str forKey:@"refresh_token"];
    NSString *access_token_str = [jsonDic objectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:access_token_str forKey:@"access_token"];
    return;
}

@end

@implementation SBMASupplierDataModel

@end

@implementation SBMADataModel

@end

@implementation OrderMTDataModel

@end

@implementation OrderDetailDataModel

@end

@implementation OrderData_Data

@end

@implementation ReplanDataModel

@end

@implementation UserMessageModel

@end

@implementation SBMMessageModel

@end