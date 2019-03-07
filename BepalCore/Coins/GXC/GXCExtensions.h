//
//  GXCExtensions.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *GXC_KEY_EXTENSIONS = @"extensions";

@interface GXCExtensions : NSObject {
    NSMutableArray *extensions;
}

- (instancetype)initWithArray:(NSArray*)arr;
- (id)toJson;
- (NSData*)toByte;

@end
