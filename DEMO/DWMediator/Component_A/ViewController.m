//
//  ViewController.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "ViewController.h"
#import "DWMediator.h"
#import "Protocol.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self macroModule];
}

///URL跳转
-(void)gotoURL {
    NSString * str = @"goto://AVC_Protocol?1=2&3=4";
    id<AVC_Protocol>m = [DWMediator createModuleWithURL:str];
    [m configNewAVCWithEventCallbackWithCurrentVC:self];
}

///普通生成实例
-(void)normalModule {
    id<AVC_Protocol>m = [DWMediator createModuleWithProtocol:@protocol(AVC_Protocol) userInfo:@{@"bgColor":[UIColor greenColor]} cache:NO eventCallback:^id(NSString *eventName, NSInteger subType, id userInfo) {
        NSLog(@"VC收到AViewController的消息：%@-%ld,%@",eventName,subType,userInfo);
        return @"VC回复已接收到消息";
    }];
    
    [m configNewAVCWithEventCallbackWithCurrentVC:self];
    ///新控制器点击发送消息
}

///宏生成实例
-(void)macroModule {
    DWMEDIA_MODULE(m, AVC_Protocol, @{@"bgColor":[UIColor blueColor]});
    [m configNewAVCWithEventCallbackWithCurrentVC:self];
}


@end
