//
//  GXCSerializable.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXCSerializable <NSObject>

- (NSData*)toByte;
- (id)toJson;

@end
