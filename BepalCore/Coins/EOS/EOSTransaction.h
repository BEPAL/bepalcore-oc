//
//  EOSTransaction.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAction.h"

@interface EOSTransaction : NSObject

@property (assign, nonatomic) NSData* chainID;
@property (assign, nonatomic) uint32_t expiration;
@property (assign, nonatomic) uint16_t blockNum;
@property (assign, nonatomic) uint32_t blockPrefix;
@property (assign, nonatomic) uint32_t netUsageWords;
@property (assign, nonatomic) uint8_t kcpuUsage;
@property (assign, nonatomic) uint32_t delaySec;

@property (strong, nonatomic) NSMutableArray<EOSAction*> *contextFreeActions;
@property (strong, nonatomic) NSMutableArray<EOSAction*> *actions;
@property (strong, nonatomic) NSMutableDictionary *extensionsType;

@property (strong, nonatomic) NSMutableArray<NSData*> *signature;

+ (void)sortAccountName:(NSMutableArray<EOSAccountName*>*)accountNames;
- (NSData*)toByte;
- (void)parse:(NSData *)data;
- (NSData*)toSignData;
- (NSData*)getSignHash;
- (NSDictionary*)toJson;
+ (NSString*)toEOSSignature:(NSData*)data;
- (EOSAccountName*)getOtherScope:(EOSAccountName*)name;
- (NSData*)getTxID;

@end
