//
//  BaseOperation.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCBaseOperation.h"
#import "Categories.h"
#import "GXCOperationType.h"

@implementation GXCBaseOperation

- (instancetype)initWithType:(uint32_t)type
{
    self = [super init];
    if (self) {
        _opType = type;
        _extensions = [GXCExtensions new];
    }
    return self;
}

- (void)fromJson:(NSDictionary*)dic {
    _fee = [[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_FEE]];
    _extensions = [[GXCExtensions alloc] initWithArray:dic[GXC_KEY_EXTENSIONS]];
}

- (id)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_fee.toJson forKey:GXC_KEY_FEE];
    [dic setValue:_extensions.toJson forKey:GXC_KEY_EXTENSIONS];
    return dic;
}

- (NSData *)toByte {
    return nil;
}


- (NSMutableArray*)toJsonArray {
    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:@(_opType)];
    [arr addObject:self.toJson];
    return arr;
}

- (NSData*)toOpByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt8:_opType];
    [data appendData:self.toByte];
    return data;
}

- (void)formJsonDic:(NSDictionary*)dic {
    _fee = [[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_FEE]];
    _extensions = [[GXCExtensions alloc] initWithArray:dic[GXC_KEY_EXTENSIONS]];
}

+ (GXCBaseOperation*)formJsonArray:(NSArray*)array {
    GXCBaseOperation *operation = nil;
    @try {
        int type = [array[0] intValue];
        if (type == GXC_OP_TRANSFER_OPERATION) {
//            operation = new TxOperation();
//            operation.fromJson(array.getJSONObject(1));
        } else if (type == GXC_OP_ACCOUNT_CREATE_OPERATION) {
//            operation = new CreateAccountOperation();
//            operation.fromJson(array.getJSONObject(1));
        }
    } @catch (NSException *ex) {
    }
    return operation;
}

@end
