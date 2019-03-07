//
//  EOSBuyRamMessageData.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAsset.h"
#import "EOSAccountName.h"
#import "EOSMessageData.h"

@interface EOSBuyRamMessageData : NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *payer;
@property (strong, nonatomic) EOSAccountName *receiver;
@property (strong, nonatomic) EOSAsset *quant;

@end
