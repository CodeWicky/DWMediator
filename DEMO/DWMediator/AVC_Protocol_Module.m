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
@synthesize eventCallback;
-(void)configNewAVCWithEventCallbackWithCurrentVC:(id)vc {
    AViewController * avc = [AViewController new];
    avc.eventCallback = self.eventCallback;
    [vc presentViewController:avc animated:YES completion:nil];
}

@end
