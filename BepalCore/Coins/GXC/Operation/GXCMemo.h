//
//  GXCMemo.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXCSerializable.h"
#import "GXCAddress.h"

static NSString *GXC_KEY_FROM = @"from";
static NSString *GXC_KEY_TO = @"to";
static NSString *GXC_KEY_NONCE = @"nonce";
static NSString *GXC_KEY_MESSAGE = @"message";

@interface GXCMemo : NSObject<GXCSerializable>

@property (strong, nonatomic) GXCAddress *from;
@property (strong, nonatomic) GXCAddress *to;
@property (strong, nonatomic) NSData *nonce;
@property (strong, nonatomic) NSData *enMessage;
@property (strong, nonatomic) NSData *message;

- (instancetype)initWithJson:(NSDictionary*)json;
- (instancetype)initWithAddressFrom:(GXCAddress*)from To:(GXCAddress*)to Nonce:(NSData*)nonce;
- (instancetype)initWithKeyFrom:(GXCECKey*)from To:(GXCECKey*)to Nonce:(NSData*)nonce;
- (NSData*)encryptWithKey:(GXCECKey*)key Message:(NSData*)message;
- (NSData*)decryptMessage:(GXCECKey*)key;

@end
