//
//  EOSKeyPermissionWeight.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableData+Extend.h"
#import "NSData+Extend.h"

@class EOSKeyPermissionWeightPubKey;

@interface EOSKeyPermissionWeight : NSObject

@property (strong, nonatomic) EOSKeyPermissionWeightPubKey *pubKey;
@property (assign, nonatomic) uint16_t weight;

- (instancetype)init:(NSData*)pubKey;
- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;
@end


@interface EOSKeyPermissionWeightPubKey : NSObject {
}
@property (assign, nonatomic) uint32_t Type;
@property (strong, nonatomic) NSData *PubKey;//33 byte

- (instancetype)init:(NSData*)data;

- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;

@end
