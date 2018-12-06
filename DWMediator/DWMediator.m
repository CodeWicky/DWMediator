//
//  DWMediator.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "DWMediator.h"

static DWMediator * _inner_mediator = nil;
@interface DWMediator ()

@property (nonatomic ,strong) NSMutableDictionary * moduleCache;

@end

@implementation DWMediator

#pragma mark --- interface method ---
+(id)createModuleWithProtocol:(Protocol *)protocol cache:(BOOL)cache {
    return [self createModuleWithProtocol:protocol cache:cache eventCallback:nil];
}

+(id)createModuleWithProtocol:(Protocol *)protocol cache:(BOOL)cache eventCallback:(DWMediatorEventCallback)eventCallback {
    NSString * protocolString = NSStringFromProtocol(protocol);
    NSString * classString = [protocolString stringByAppendingString:@"_Module"];
    Class clazz = NSClassFromString(classString);
    if (!clazz) {
        return nil;
    }
    if (![clazz conformsToProtocol:protocol]) {
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
        if (eventCallback && [module conformsToProtocol:@protocol(DWMediatorEventProtocol)]) {
            ((id<DWMediatorEventProtocol>)module).eventCallback = eventCallback;
        }
    }
    if (!module) {
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
