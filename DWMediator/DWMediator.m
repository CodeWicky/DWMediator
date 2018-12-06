//
//  DWMediator.m
//  DWMediator
//
//  Created by Wicky on 2018/12/6.
//  Copyright © 2018 Wicky. All rights reserved.
//

#import "DWMediator.h"

static DWMediator * _inner_mediator = nil;
@implementation DWMediator

#pragma mark --- singleton ---
+(instancetype)mediator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inner_mediator = [[DWMediator alloc] init];
    });
    return _inner_mediator;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inner_mediator = [super allocWithZone:zone];
    });
    return _inner_mediator;
}

-(id)copyWithZone:(struct _NSZone *)zone {
    return _inner_mediator;
}

-(id)mutableCopyWithZone:(struct _NSZone *)zone {
    return _inner_mediator;
}

@end
