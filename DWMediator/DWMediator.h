//
//  DWMediator.h
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 DWMediator
 组件间解耦中间件
 用于实现组件间的通信。
 
 使用方法：
 
 组件A、组件B同时依赖DWMediator及Protocol文件。例如为B组件添加 B_Protocol 进行调用，则在B组件中建立 B_Protocol_Module ，并遵循 B_Protocol 协议。在 module 中的协议方法调用组件B方法，并在组件A中使用 DWMediator 获取遵循 B_Protocol 协议的实例 module，并使用 module 调用协议方法完成组件间通信。
 
 具体使用方法请查看github(https://github.com/CodeWicky/DWMediator)中的注释或者提供的DEMO。
 
 version 0.0.1
 提供基础跳转功能
 
 version 0.0.2
 提供相关协议
 
 version 0.0.3
 修复因url中含有中文导致url生成为nil的bug
 */

extern NSString * const DWMediatorSystemEvent;///系统事件
extern NSString * const DWMediatorUIEvent;///UI事件
extern NSString * const DWMediatorCustomEvent;///自定义事件

typedef id(^DWMediatorEventCallback)(NSString * eventName,NSInteger subType,id userInfo);

/**
 中间件事件协议
 
 当module遵循此协议后，生成module实例时可指定事件回调给module。
 module操作的组建可以遵循此协议并将module自身携带的回调赋值给组建。组建通过调用回调完成组件间通信
 */

///module遵循协议后，在 @implementation 下调用此宏来添加属性
#define CONFIRM_DWMEDIA_EVENT_PROTOCOL @synthesize dw_EventCallback;
@protocol DWMediatorEventProtocol <NSObject>

@property (nonatomic ,copy) DWMediatorEventCallback dw_EventCallback;

@end


/**
 中间件Module协议
 
 当module遵循此协议后，可以实现 +createInstance 方法来自定义module的实例化过程。否则将以默认方法 +new 实例化module。
 
 当module遵循此协议后，module可以携带传入的userInfo，以便在module操作组件时使用相关参数
 */

#define CONFIRM_DWMEDIA_MODULE_PROTOCOL @synthesize dw_UserInfo;
@protocol DWMediatorModuleProtocol <NSObject>

///module携带的参数
@property (nonatomic ,strong) id dw_UserInfo;

@optional
///module创建协议方法（如果实现将以此方法实例化module。否则调用 +new 进行实例化）
+(instancetype)createInstance;

@end

/**
 中间件核心类
 */

///快速以protocol生成一个实例
#define DWMEDIA_MODULE(_varName,_protocol,_userInfo) \
id<_protocol> _varName = [DWMediator createModuleWithProtocol:@protocol(_protocol) userInfo:_userInfo]
@interface DWMediator : NSObject

///全局动态化查找组建失败回调
@property (nonatomic ,copy) void(^noResponseCallback)(Protocol * protocol,NSError * error);


///单例方法
+(instancetype)mediator;

///以URL创建Module
+(id)createModuleWithURL:(NSString *)urlString;


/**
 通过URL创建Module

 @param urlString URL
 @param cache 是否缓存module实例
 @param eventCallback module携带的事件回调
 @return module实例
 */
+(id)createModuleWithURL:(NSString *)urlString cache:(BOOL)cache eventCallback:(DWMediatorEventCallback)eventCallback;


/**
 通过协议创建module

 @param protocol 协议
 @param userInfo module携带的参数
 @return module实例
 */
+(id)createModuleWithProtocol:(Protocol *)protocol userInfo:(id)userInfo;


/**
 通过协议创建module

 @param protocol 协议
 @param userInfo module携带的参数
 @param cache 是否缓存module实例
 @param eventCallback module携带的事件回调
 @return module实例
 */
+(id)createModuleWithProtocol:(Protocol *)protocol userInfo:(id)userInfo cache:(BOOL)cache eventCallback:(DWMediatorEventCallback)eventCallback;


/**
 以协议移除缓存的module实例

 @param protocol 指定协议
 */
+(void)removeModuleCacheWithProtocol:(Protocol *)protocol;


/**
 移除所有缓存的module实例
 */
+(void)clearModuleCache;

@end
