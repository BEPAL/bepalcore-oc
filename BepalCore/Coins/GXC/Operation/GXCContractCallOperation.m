//
//  GXCContractCallOperation.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2019/2/18.
//  Copyright © 2019 潘孝钦. All rights reserved.
//

#import "GXCContractCallOperation.h"
#import "GXCOperationType.h"
#import "Categories.h"
#import "EOSAccountName.h"

@implementation GXCContractCallOperation

- (instancetype)init
{
    self = [super initWithType:GXC_OP_CONTRACT_CALL_OPERATION];
    if (self) {
        
    }
    return self;
}

- (id)toJson {
    NSMutableDictionary *dic = [super toJson];
    [dic setValue:_account.getId forKey:GXC_KEY_ACCOUNT];
    [dic setValue:_amount.toJson forKey:GXC_KEY_AMOUNT];
    [dic setValue:_contractAccount.getId forKey:GXC_KEY_CONTRACT_ID];
    [dic setValue:_methodName forKey:GXC_KEY_METHOD_NAME];
    [dic setValue:_data.hexString forKey:GXC_KEY_DATA];
    return dic;
}

- (void)formJsonDic:(NSDictionary *)dic {
    [super formJsonDic:dic];
    _account = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_ACCOUNT]];
    _amount = [[GXCOptional alloc] initWithField:[[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_AMOUNT]]];
    _contractAccount = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_CONTRACT_ID]];
    _methodName = dic[GXC_KEY_METHOD_NAME];
    _data = [dic[GXC_KEY_DATA] hexToData];
}

- (NSData *)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendData:self.fee.toByte];
    [data appendData:self.account.toByte];
    [data appendData:self.contractAccount.toByte];
    [data appendData:self.amount.toByte];
    [data appendData:[EOSAccountName getData:_methodName]];
    [data appendUVar:_data.length];
    [data appendData:_data];
    [data appendData:self.extensions.toByte];
    return data;
}

@end
