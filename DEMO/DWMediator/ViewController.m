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
    self.view.backgroundColor = [UIColor redColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id<AVC_Protocol> m = [DWMediator createModuleWithProtocol:@protocol(AVC_Protocol) cache:YES eventCallback:^id(NSString *eventName, NSInteger subType, id userInfo) {
        NSLog(@"%@-%ld-%@",eventName,subType,userInfo);
        return @(YES);
    }];
    [m configNewAVCWithEventCallbackWithCurrentVC:self];
}


@end
