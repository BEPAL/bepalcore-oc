//
//  TxOperation.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCTxOperation.h"
#import "GXCOperationType.h"
#import "Categories.h"

@implementation GXCTxOperation

- (instancetype)init
{
    self = [super initWithType:GXC_OP_TRANSFER_OPERATION];
    if (self) {
        
    }
    return self;
}

- (NSData *)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendData:self.fee.toByte];
    [data appendData:self.from.toByte];
    [data appendData:self.to.toByte];
    [data appendData:self.amount.toByte];
    if (_memo != nil) {
        [data appendData:_memo.toByte];
    } else {
        [data appendUInt8:0];
    }
    [data appendData:self.extensions.toByte];
    return data;
}

- (void)formJsonDic:(NSDictionary *)dic {
    [super formJsonDic:dic];
    _from = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_FROM]];
    _to = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_TO]];
    _amount = [[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_AMOUNT]];
    if (dic[GXC_KEY_MEMO]) {
        _memo = [[GXCMemo alloc] initWithJson:dic[GXC_KEY_MEMO]];
    }
}

- (id)toJson {
    NSMutableDictionary *dic = [super toJson];
    [dic setValue:_from.getId forKey:GXC_KEY_FROM];
    [dic setValue:_to.getId forKey:GXC_KEY_TO];
    [dic setValue:_amount.toJson forKey:GXC_KEY_AMOUNT];
    if (_memo != nil) {
        [dic setValue:_memo.toJson forKey:GXC_KEY_MEMO];
    }
    return dic;
}

@end
