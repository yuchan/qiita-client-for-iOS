//
//  QiitaClient.m
//
//  Created by Ohashi Yusuke on 11/17/13.
//  Copyright (c) 2013 Ohashi Yusuke. All rights reserved.
//

#import "QiitaClient.h"

#define API_BASE_URL @"https://qiita.com/api/v1/"

NS_ENUM(NSInteger, kHTTPMethod)
{
    kHTTPMethodGET = 0,
    kHTTPMethodPOST = 1,
    kHTTPMethodPUT = 2,
    kHTTPMethodDELETE = 3,
    kHTTPMethodPATCH = 4,
    kHTTPMethodHEAD = 5
};

@interface QiitaClient()
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *token;
@end

@implementation QiitaClient

+ (QiitaClient *) sharedClient
{
    static QiitaClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[QiitaClient alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    });
    
    return sharedClient;
}

- (id) initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
    }
    
    return self;
}

#pragma mark Private Methods

/**
 * Connecting...
 */
- (void) connectWithPath:(NSString *)path
                parameta:(NSMutableDictionary *)queryParameta
                  method:(NSInteger)method
                 handler:(AFCallbackHandler) handler
{
    if (queryParameta == nil) {
        queryParameta = [[NSMutableDictionary alloc] init];
    }
    
    if (self.token && [self.token length] > 0) {
        [queryParameta setObject:self.token forKey:@"token"];
    }
    
    typedef void (^AFSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
    AFSuccessBlock success =  ^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] &&
            [responseObject objectForKey:@"token"]) {
            [self setUsername:[responseObject objectForKey:@"url_name"]];
            [self setToken:[responseObject objectForKey:@"token"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(responseObject, nil);
        });
    };
    
    typedef void (^AFErrorBlock)(NSURLSessionDataTask *task, NSError *error);
    AFErrorBlock error = ^(NSURLSessionDataTask *task, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, error);
        });
    };
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_BASE_URL, path];
    
    switch (method) {
        case kHTTPMethodGET:
            [super GET:url parameters:queryParameta success:success failure:error];
            break;
        case kHTTPMethodPOST:
            [super POST:url parameters:queryParameta success:success failure:error];
            break;
        case kHTTPMethodPUT:
            [super PUT:url parameters:queryParameta success:success failure:error];
            break;
        case kHTTPMethodDELETE:
            [super DELETE:url parameters:queryParameta success:success failure:error];
            break;
        default:
            break;
    }

}

- (NSString *) urlName
{
    return self.username;
}

- (NSString *) userToken
{
    return self.token;
}

- (void) rate_limit:(AFCallbackHandler)handler
{
    [self connectWithPath:@"rate_limit" parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) auth:(NSString *)userName password:(NSString *)passWord callback:(AFCallbackHandler)handler
{
    [self setUsername:userName];
    [self setPassword:passWord];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.username,@"url_name",self.password,@"password",nil];
    [self connectWithPath:@"auth" parameta:param method:kHTTPMethodPOST handler:handler];
}

- (void) user:(AFCallbackHandler)handler
{
    [self connectWithPath:@"user" parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) stocks:(AFCallbackHandler)handler
{
    [self connectWithPath:@"stocks" parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) items:(AFCallbackHandler)handler
{
    [self connectWithPath:@"items" parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) tags:(AFCallbackHandler)handler
{
    [self connectWithPath:@"tags" parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) userInfo:(NSString *)userName callback:(AFCallbackHandler)handler
{
    NSString *path = [[NSString alloc] initWithFormat:@"users/%@",userName];
    [self connectWithPath:path parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) userItems:(NSString *)userName team_url_name:(NSString *)teamName callback:(AFCallbackHandler)handler
{
    NSString *path = [[NSString alloc] initWithFormat:@"users/%@/items",userName];
    NSMutableDictionary *param = nil;
    
    if (teamName != nil) {
        param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:teamName,@"team_url_name",nil];
    }
    
    [self connectWithPath:path parameta:param method:kHTTPMethodGET handler:handler];
}

- (void) userStocks:(NSString *)userName callback:(AFCallbackHandler)handler
{
    NSString *path = [[NSString alloc] initWithFormat:@"users/%@/stocks",userName];
    
    [self connectWithPath:path parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) following_users:(NSString *)userName callback:(AFCallbackHandler)handler
{
    NSString *path = [[NSString alloc] initWithFormat:@"users/%@/following_users",userName];
    
    [self connectWithPath:path parameta:nil method:kHTTPMethodGET handler:handler];
}

- (void) following_tags:(NSString *)userName callback:(AFCallbackHandler)handler
{
    NSString *path = [[NSString alloc] initWithFormat:@"users/%@/following_tags",userName];
    
    [self connectWithPath:path parameta:nil method:kHTTPMethodGET handler:handler];
}

#pragma mark public API

+ (void) rate_limit:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] rate_limit:handler];
}

+ (void) tags:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] tags:handler];
}

+ (NSString *)token
{
    return [[QiitaClient sharedClient] userToken];
}

+ (NSString *)username
{
    return [[QiitaClient sharedClient] urlName];
}

+ (void) auth:(NSString *)userName password:(NSString *)password callback:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] auth:userName password:password callback:handler];
}

+ (void) user:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] user:handler];
}

+ (void) stocks:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] stocks:handler];
}

+ (void) userInfo:(NSString *)userName callback:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] userInfo:userName callback:handler];
}

+ (void) userItems:(NSString *)userName team_url_name:(NSString*)teamName callback:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] userItems:userName team_url_name:teamName callback:handler];
}

+ (void) userStocks:(NSString *)userName callback:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] userStocks:userName callback:handler];
}

+ (void) userFollowingTags:(NSString *)userName callback:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] following_tags:userName callback:handler];
}

+ (void) userFollowingUsers:(NSString *)userName callback:(AFCallbackHandler)handler
{
    [[QiitaClient sharedClient] following_users:userName callback:handler];
}

@end
