//
//  TxOperation.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCBaseOperation.h"
#import "GXCUserAccount.h"
#import "GXCMemo.h"
#import "GXCAssetAmount.h"

static NSString *GXC_KEY_MEMO = @"memo";

@interface GXCTxOperation : GXCBaseOperation

@property (strong, nonatomic) GXCUserAccount *from;
@property (strong, nonatomic) GXCUserAccount *to;
@property (strong, nonatomic) GXCAssetAmount *amount;
@property (strong, nonatomic) GXCMemo *memo;

@end
