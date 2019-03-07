//
//  EOSAuthority.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSKeyPermissionWeight.h"
#import "EOSAccountPermissionWeight.h"
#import "EOSWaitWeight.h"

@interface EOSAuthority : NSObject

@property (assign, nonatomic) uint32_t threshold;
@property (strong, nonatomic) NSMutableArray<EOSKeyPermissionWeight*> *keys;
@property (strong, nonatomic) NSMutableArray<EOSAccountPermissionWeight*> *accounts;
@property (strong, nonatomic) NSMutableArray<EOSWaitWeight*> *weights;

- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;
- (void)addKey:(EOSKeyPermissionWeight*)key;
- (void)addAccount:(EOSAccountPermissionWeight*)account;
@end
