//
//  DWMediatorEventModule.h
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWMediator.h"

/**
 具有事件回调携带能力的Module
 
 由于协议属性的特性，为调用 @synthesize 将不具备setter/getter。操作不当可能引起崩溃。组件对应的Module类若继承自此类可以通过 -configEventCallbackForTarget 安全的为组件设置事件回调
 */
@interface DWMediatorEventModule : NSObject<DWMediatorEventProtocol,DWMediatorModuleProtocol>

/**
 安全的给target设置事件回调

 @param target 需要设置事件回调的组件
 */
-(void)configEventCallbackForTarget:(id)target;

@end
