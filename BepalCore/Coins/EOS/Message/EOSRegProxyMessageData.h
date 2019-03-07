//
//  EOSRegProxyMessageData.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAccountName.h"
#import "EOSMessageData.h"

@interface EOSRegProxyMessageData : NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *proxy;
@property (assign, nonatomic) Boolean isProxy;

@end