//
//  Protocol.h
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//
#import "DWMediator.h"
#import <UIKit/UIKit.h>
@protocol AVC_Protocol <DWMediatorModuleProtocol>

-(void)configNewAVCWithEventCallbackWithCurrentVC:(UIViewController *)vc;

@end
