//
//  AViewController.h
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWMediator.h"

@interface AViewController : UIViewController<DWMediatorEventProtocol>

@property (nonatomic ,strong) UIColor * bgColor;

@end
