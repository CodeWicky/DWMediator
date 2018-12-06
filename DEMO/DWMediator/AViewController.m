//
//  AViewController.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "AViewController.h"

@interface AViewController ()

@end

@implementation AViewController
@synthesize eventCallback;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",self.eventCallback(@"TouchBegin",0,@{@"key":@"value"}));
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
