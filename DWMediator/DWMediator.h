//
//  DWMediator.h
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^DWMediatorEventCallback)(NSString * eventName,NSInteger subType,id userInfo);

@protocol DWMediatorEventProtocol <NSObject>

@property (nonatomic ,copy) DWMediatorEventCallback eventCallback;

@end

@protocol DWMediatorModuleProtocol <NSObject>

@optional
+(instancetype)createInstance;

@end

@interface DWMediator : NSObject

+(instancetype)mediator;

+(id)createModuleWithProtocol:(Protocol *)protocol cache:(BOOL)cache;

+(id)createModuleWithProtocol:(Protocol *)protocol cache:(BOOL)cache eventCallback:(DWMediatorEventCallback)eventCallback;

+(void)removeModuleCacheWithProtocol:(Protocol *)protocol;

+(void)clearModuleCache;

@end
