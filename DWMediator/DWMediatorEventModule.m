//
//  DWMediatorEventModule.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "DWMediatorEventModule.h"

@implementation DWMediatorEventModule
CONFIRM_DWMEDIA_EVENT_PROTOCOL
CONFIRM_DWMEDIA_MODULE_PROTOCOL

-(void)configEventCallbackForTarget:(id)target {
    if ([target conformsToProtocol:@protocol(DWMediatorEventProtocol)] && [target respondsToSelector:@selector(setDw_EventCallback:)]) {
        ((id<DWMediatorEventProtocol>)target).dw_EventCallback = self.dw_EventCallback;
    }
}

@end
