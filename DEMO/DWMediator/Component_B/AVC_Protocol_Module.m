//
//  AVC_Protocol_Module.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "AVC_Protocol_Module.h"
#import "AViewController.h"
#import <UIKit/UIKit.h>

@implementation AVC_Protocol_Module
CONFIRM_DWMEDIA_EVENT_PROTOCOL
CONFIRM_DWMEDIA_MODULE_PROTOCOL
-(void)configNewAVCWithEventCallbackWithCurrentVC:(id)vc {
    AViewController * avc = [AViewController new];
    avc.dw_EventCallback = self.dw_EventCallback;
    avc.bgColor = self.dw_UserInfo[@"bgColor"];
    [vc presentViewController:avc animated:YES completion:nil];
}

@end
