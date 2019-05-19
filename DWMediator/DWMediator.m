//
//  DWMediator.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "DWMediator.h"

NSString * const DWMediatorCreateModuleErrorDomain = @"com.DWMediator.error.createModule";
NSString * const DWMediatorSystemEvent = @"DWMediatorSystemEvent";
NSString * const DWMediatorUIEvent = @"DWMediatorUIEvent";
NSString * const DWMediatorCustomEvent = @"DWMediatorCustomEvent";

static DWMediator * _inner_mediator = nil;
@interface DWMediator ()

@property (nonatomic ,strong) NSMutableDictionary * moduleCache;

@end

@implementation DWMediator

#pragma mark --- interface method ---

+(id)createModuleWithURL:(NSString *)urlString {
    return [self createModuleWithURL:urlString cache:NO eventCallback:nil];
}

+(id)createModuleWithURL:(NSString *)urlString cache:(BOOL)cache eventCallback:(DWMediatorEventCallback)eventCallback {
    if (urlString.length == 0) {
        if ([DWMediator mediator].noResponseCallback) {
            NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:4 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Can't parse url string whose length is 0."]}];
            [DWMediator mediator].noResponseCallback(nil, err);
        }
        return nil;
    }
    
    NSURL * url = [NSURL URLWithString:urlString];
    if (!url) {
        if ([DWMediator mediator].noResponseCallback) {
            NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:5 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Can't parse url string who is invalid."]}];
            [DWMediator mediator].noResponseCallback(nil, err);
        }
        return nil;
    }
    
    ///简单兼容未填写scheme的URL，防止找不到host
    if (!url.scheme) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"goto://%@",urlString]];
    }
    
    NSString * protocolString = url.host;
    Protocol * protocol = NSProtocolFromString(protocolString);
    if (!protocol) {
        if ([DWMediator mediator].noResponseCallback) {
            NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:1 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Can't load protocol <%@>.",protocolString]}];
            [DWMediator mediator].noResponseCallback(nil, err);
        }
        return nil;
    }
    
    NSString * queryString = url.query;
    if (queryString.length == 0) {
        return [self createModuleWithProtocol:protocol userInfo:nil cache:cache eventCallback:eventCallback];
    }
    
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    NSArray * items = [queryString componentsSeparatedByString:@"&"];
    for (NSString * item in items) {
        NSArray * keyValues = [item componentsSeparatedByString:@"="];
        if (keyValues.count == 2) {
            [userInfo setValue:keyValues.lastObject forKey:keyValues.firstObject];
        }
    }
    
    if (!userInfo.allKeys.count) {
        return [self createModuleWithProtocol:protocol userInfo:nil cache:cache eventCallback:eventCallback];
    }
    
    return [self createModuleWithProtocol:protocol userInfo:userInfo cache:cache eventCallback:eventCallback];
}

+(id)createModuleWithProtocol:(Protocol *)protocol userInfo:(id)userInfo {
    return [self createModuleWithProtocol:protocol userInfo:userInfo cache:NO eventCallback:nil];
}

+(id)createModuleWithProtocol:(Protocol *)protocol userInfo:(id)userInfo cache:(BOOL)cache eventCallback:(DWMediatorEventCallback)eventCallback {
    if (!protocol) {
        NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:0 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Can't load protocol for it's nil."]}];
        [DWMediator mediator].noResponseCallback(nil, err);
        return nil;
    }
    NSString * protocolString = NSStringFromProtocol(protocol);
    NSString * classString = [protocolString stringByAppendingString:@"_Module"];
    Class clazz = NSClassFromString(classString);
    if (!clazz) {
        if ([DWMediator mediator].noResponseCallback) {
            NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:2 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Can't load class <%@>",classString]}];
            [DWMediator mediator].noResponseCallback(protocol, err);
        }
        return nil;
    }
    if (![clazz conformsToProtocol:protocol]) {
        if ([DWMediator mediator].noResponseCallback) {
            NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:3 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Class named %@ doesn't confirms to potocol <%@>",classString,protocolString]}];
            [DWMediator mediator].noResponseCallback(protocol, err);
        }
        return nil;
    }
    id module = nil;
    if (cache) {
        module = [DWMediator mediator].moduleCache[classString];
        if (module) {
            return module;
        }
    }
    if (!cache || !module) {
        if ([clazz conformsToProtocol:@protocol(DWMediatorModuleProtocol)] && [clazz respondsToSelector:@selector(createInstance)]) {
            module = [((id<DWMediatorModuleProtocol>)clazz) createInstance];
        } else {
            module = [[clazz alloc] init];
        }
        if (eventCallback && [module conformsToProtocol:@protocol(DWMediatorEventProtocol)] && [module respondsToSelector:@selector(setDw_EventCallback:)]) {
            ((id<DWMediatorEventProtocol>)module).dw_EventCallback = eventCallback;
        }
        if ([module conformsToProtocol:@protocol(DWMediatorModuleProtocol)] && [module respondsToSelector:@selector(setDw_UserInfo:)]) {
            ((id<DWMediatorModuleProtocol>)module).dw_UserInfo = userInfo;
        }
    }
    if (!module) {
        if ([DWMediator mediator].noResponseCallback) {
            NSError * err = [NSError errorWithDomain:DWMediatorCreateModuleErrorDomain code:4 userInfo:@{@"err_msg":[NSString stringWithFormat:@"Something wrong on initializing an instance of class <%@>",classString]}];
            [DWMediator mediator].noResponseCallback(protocol, err);
        }
        return nil;
    }
    if (cache) {
        [DWMediator mediator].moduleCache[classString] = module;
    }
    return module;
}

+(void)removeModuleCacheWithProtocol:(Protocol *)protocol {
    NSString * protocolString = NSStringFromProtocol(protocol);
    NSString * classString = [protocolString stringByAppendingString:@"_Module"];
    [[DWMediator mediator].moduleCache removeObjectForKey:classString];
}

+(void)clearModuleCache {
    [[DWMediator mediator].moduleCache removeAllObjects];
}

#pragma mark --- setter/getter ---
-(NSMutableDictionary *)moduleCache {
    if (!_moduleCache) {
        _moduleCache = [NSMutableDictionary dictionary];
    }
    return _moduleCache;
}

#pragma mark --- singleton ---
+(instancetype)mediator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inner_mediator = [[DWMediator alloc] init];
    });
    return _inner_mediator;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inner_mediator = [super allocWithZone:zone];
    });
    return _inner_mediator;
}

-(id)copyWithZone:(struct _NSZone *)zone {
    return _inner_mediator;
}

-(id)mutableCopyWithZone:(struct _NSZone *)zone {
    return _inner_mediator;
}

@end
