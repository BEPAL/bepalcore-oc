//
//  ErrorTool.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/7/17.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "ErrorTool.h"

@implementation ErrorTool

+ (void)checkArgument:(BOOL)bo Mess:(NSString*)mess {
    if (!bo) {
        @throw [[NSException alloc] initWithName:@"Argument Exception" reason:mess userInfo:nil];
    }
}

+ (void)checkArgument:(BOOL)bo Mess:(NSString*)mess Log:(NSString*)log {
    if (!bo) {
        @throw [[NSException alloc] initWithName:@"Argument Exception" reason:[NSString stringWithFormat:@"mess:%@ log:%@",mess,log] userInfo:nil];
    }
}

+ (void)checkNotNull:(id)data {
    if (data == nil) {
        @throw [[NSException alloc] initWithName:@"NULL Exception" reason:@"空的对象" userInfo:nil];
    }
}

+ (void)throwMessage:(NSString*)mess {
    @throw [[NSException alloc] initWithName:@"Data Exception" reason:mess userInfo:nil];
}

+ (void)unimplementedMethod {
    @throw [[NSException alloc] initWithName:@"Unimplemented Method Exception" reason:@"未实现该方法" userInfo:nil];
}

@end
