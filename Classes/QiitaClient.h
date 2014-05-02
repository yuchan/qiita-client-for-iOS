//
//  QiitaClient.h
//
//  Created by Ohashi Yusuke on 11/17/13.
//  Copyright (c) 2013 Ohashi Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

typedef void (^AFCallbackHandler)(id responseObject, NSError *error);

@interface QiitaClient : AFHTTPSessionManager

+ (void) rate_limit:(AFCallbackHandler)handler;
+ (void) auth:(NSString *)userName
     password:(NSString *)password
     callback:(AFCallbackHandler)handler;
+ (NSString *)username;
+ (NSString *)token;
+ (void) user:(AFCallbackHandler)handler;
+ (void) stocks:(AFCallbackHandler)handler;
+ (void) userInfo:(NSString *)userName callback:(AFCallbackHandler)handler;
+ (void) userItems:(NSString *)userName team_url_name:(NSString*)teamName callback:(AFCallbackHandler)handler;
+ (void) userStocks:(NSString *)userName callback:(AFCallbackHandler)handler;
@end
