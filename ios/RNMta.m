#import "MTA.h"
#import "MTAConfig.h"
#import "RNMta.h"
#import "MTA+Account.h"

@implementation RNMta {
    BOOL _isInitSuccess;
}

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}


#pragma 初始化

RCT_REMAP_METHOD(startWithAppkey,
          startWithAppkey:(NSString *)anAppkey
                  channel:(NSString *)aChannel
                  isDebug:(BOOL)isDebug
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if(![anAppkey isEqualToString:@""]) {
        [MTA startWithAppkey:anAppkey];
        _isInitSuccess = YES;
        NSLog(@"MTA init success. appKey: %@", anAppkey);
    } else {
        _isInitSuccess = NO;
        NSLog(@"There is no appKey for MTA.");
    }
    resolve([self getResolveResFromBool:_isInitSuccess]);
}

RCT_REMAP_METHOD(checkInitialResult,
         checkInitialResultWithResolver:(RCTPromiseResolveBlock)resolve
                               rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([self getResolveResFromBool:_isInitSuccess]);
}


#pragma 统计页面时长

RCT_REMAP_METHOD(trackPageBegin,
               trackPageBegin:(NSString *)aPage
                       appkey:(NSString *)anAppkey
                     resolver:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject)
{
    [MTA trackPageViewBegin:aPage appkey:anAppkey];
    resolve([self getResolveResFromBool:YES]);
}

RCT_REMAP_METHOD(trackPageEnd,
               trackPageEnd:(NSString *)aPage
                     appkey:(NSString *)anAppkey
                 isRealTime:(BOOL)isRealTime
                   resolver:(RCTPromiseResolveBlock)resolve
                   rejecter:(RCTPromiseRejectBlock)reject)
{
    [MTA trackPageViewEnd:aPage appkey:anAppkey isRealTime:isRealTime];
    resolve([self getResolveResFromBool:YES]);
}


#pragma 自定义事件

RCT_REMAP_METHOD(trackCustomEvent,
                trackCustomEvent:(NSString *)aEventId
                  customerParams:(NSDictionary *)aCustomerParams
                          appkey:(NSString *)anAppkey
                      isRealTime:(BOOL)isRealTime
                        resolver:(RCTPromiseResolveBlock)resolve
                        rejecter:(RCTPromiseRejectBlock)reject)
{
    MTAErrorCode errCode = [MTA trackCustomKeyValueEvent:aEventId
                                                   props:aCustomerParams
                                                  appkey:anAppkey
                                              isRealTime:isRealTime];
    resolve([NSNumber numberWithInteger:(NSInteger)errCode]);
}

RCT_REMAP_METHOD(trackCustomEventBegin,
               trackCustomEventBegin:(NSString *)aEventId
                      customerParams:(NSDictionary *)aCustomerParams
                              appkey:(NSString *)anAppkey
                            resolver:(RCTPromiseResolveBlock)resolve
                            rejecter:(RCTPromiseRejectBlock)reject)
{
    MTAErrorCode errCode = [MTA trackCustomKeyValueEventBegin:aEventId props:aCustomerParams appkey:anAppkey];
    resolve([NSNumber numberWithInteger:(NSInteger)errCode]);
}

RCT_REMAP_METHOD(trackCustomEventEnd,
               trackCustomEventEnd:(NSString *)aEventId
                    customerParams:(NSDictionary *)aCustomerParams
                            appkey:(NSString *)anAppkey
                        isRealTime:(BOOL)isRealTime
                          resolver:(RCTPromiseResolveBlock)resolve
                          rejecter:(RCTPromiseRejectBlock)reject)
{
    MTAErrorCode errCode = [MTA trackCustomKeyValueEventEnd:aEventId
                                                      props:aCustomerParams
                                                     appkey:anAppkey
                                                 isRealTime:isRealTime];
    resolve([NSNumber numberWithInteger:(NSInteger)errCode]);
}

RCT_REMAP_METHOD(trackCustomEventDuration,
             trackCustomEventDuration:(NSString *)aEventId
                             duration:(float)aDuration
                       customerParams:(NSDictionary *)aCustomerParams
                               appkey:(NSString *)anAppkey
                           isRealTime:(BOOL)isRealTime
                             resolver:(RCTPromiseResolveBlock)resolve
                             rejecter:(RCTPromiseRejectBlock)reject)
{
    MTAErrorCode errCode = [MTA trackCustomKeyValueEventDuration:aDuration
                                                     withEventid:aEventId
                                                           props:aCustomerParams
                                                          appKey:anAppkey
                                                      isRealTime:isRealTime];
    resolve([NSNumber numberWithInteger:(NSInteger)errCode]);
}


#pragma 使用时长

RCT_REMAP_METHOD(trackActiveBegin,
         trackActiveBeginResolver:(RCTPromiseResolveBlock)resolve
                         rejecter:(RCTPromiseRejectBlock)reject)
{
    [MTA trackActiveBegin];
    resolve([NSNumber numberWithBool:YES]);
}

RCT_REMAP_METHOD(trackActiveEnd,
         trackActiveEndResolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject)
{
    [MTA trackActiveEnd];
    resolve([NSNumber numberWithBool:YES]);
}


#pragma 用户属性

RCT_REMAP_METHOD(setUserProperty,
                 setUserProperty:(NSDictionary *)aCustomerParams
                        resolver:(RCTPromiseResolveBlock)resolve
                        rejecter:(RCTPromiseRejectBlock)reject)
{
    [MTA setUserProperty:aCustomerParams];
    resolve([NSNumber numberWithBool:YES]);
}

#pragma 统计触发账号数

RCT_REMAP_METHOD(reportAccount,
  reportAccountWithAccountType:(int)accountType
                        openId:(NSString *)openId
                  bookInUserId:(NSString *)bookInUserId
                 accountStatus:(NSString *)accountStatus
                      resolver:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject)
{
    MTAAccountInfo *info1 = [MTAAccountInfo new];
    info1.type = [self convertAccountType:accountType];
    info1.account = openId;
    info1.accountStatus = [self convertAccountStatus:accountStatus];
    
    MTAAccountInfo *info2 = [MTAAccountInfo new];
    info2.type = MTAAccountCustom;
    info2.account = bookInUserId;
    info2.accountStatus = [self convertAccountStatus:accountStatus];
    
    [MTA reportAccountExt:@[info1, info2]];
    resolve([NSNumber numberWithBool:YES]);
}

#pragma other
- (NSNumber *)getResolveResFromBool:(BOOL)boolValue
{
    return [NSNumber numberWithBool:boolValue];
}

- (MTAAccountTypeExt)convertAccountType:(int)type {
    if (type == 1) {
        return MTAAccountPhone;
    } else if (type == 2) {
        return MTAAccountWeixin;
    } else if (type == 3) {
        return MTAAccountQQOpenid;
    } else if (type == 4) {
        return MTAAccountWeibo;
    } else {
        return MTAAccountUndefined;
    }
}

- (MTAAccountStatus)convertAccountStatus:(NSString *)accountStatus {
    if ([accountStatus isEqual:@"LOGIN"]) {
        return MTAAccountStatusNormal;
    } else if ([accountStatus isEqual:@"LOGOUT"]) {
        return MTAAccountStatusLogout;
    } else {
        return MTAAccountStatusUndefined;
    }
}

@end
