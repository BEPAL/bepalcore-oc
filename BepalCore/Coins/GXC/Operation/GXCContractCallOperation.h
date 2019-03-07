//
//  GXCContractCallOperation.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2019/2/18.
//  Copyright © 2019 潘孝钦. All rights reserved.
//

#import "GXCBaseOperation.h"
#import "GXCUserAccount.h"
#import "GXCAssetAmount.h"
#import "GXCOptional.h"

static NSString *GXC_KEY_ACCOUNT = @"account";
static NSString *GXC_KEY_CONTRACT_ID = @"contract_id";
static NSString *GXC_KEY_METHOD_NAME = @"method_name";
static NSString *GXC_KEY_DATA = @"data";

@interface GXCContractCallOperation : GXCBaseOperation

@property (strong, nonatomic) GXCUserAccount *account;
@property (strong, nonatomic) GXCOptional *amount;
@property (strong, nonatomic) GXCUserAccount *contractAccount;
@property (strong, nonatomic) NSString *methodName;
@property (strong, nonatomic) NSData *data;

@end
