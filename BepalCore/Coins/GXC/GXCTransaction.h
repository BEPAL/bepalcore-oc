//
//  GXCTransaction.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXCBaseOperation.h"
#import "GXCECKey.h"

static int GXC_DEFAULT_EXPIRATION_TIME = 30;

static NSString *GXC_KEY_EXPIRATION = @"expiration";
static NSString *GXC_KEY_SIGNATURES = @"signatures";
static NSString *GXC_KEY_OPERATIONS = @"operations";
static NSString *GXC_KEY_REF_BLOCK_NUM = @"ref_block_num";
static NSString *GXC_KEY_REF_BLOCK_PREFIX = @"ref_block_prefix";

@interface GXCTransaction : NSObject

@property (strong, nonatomic) NSData *chainID;
@property (assign, nonatomic) uint64_t expiration;
@property (assign, nonatomic) uint16_t blockNum;
@property (assign, nonatomic) uint32_t blockPrefix;

@property (strong, nonatomic) NSMutableArray<GXCBaseOperation*> *operations;
@property (strong, nonatomic) GXCExtensions *extensions;
@property (strong, nonatomic) NSMutableArray *signature;

- (NSDictionary*)toJson;
- (NSData*)sign:(GXCECKey*)key;
- (NSData*)getTxID;
- (NSData*)getSignHash;

@end
