//
//  AViewController.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "AViewController.h"
#import "ViewController.h"

@interface AViewController ()

@end

@implementation AViewController
@synthesize dw_EventCallback;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.bgColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dw_EventCallback) {
        NSLog(@"%@",self.dw_EventCallback(@"TouchBegin",0,@{@"key":@"value"}));
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
