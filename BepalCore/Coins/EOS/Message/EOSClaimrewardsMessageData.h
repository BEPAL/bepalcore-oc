//
//  EOSClaimrewardsMessageData.h
//  BepalSdk
//
//  Created by Hyq on 2018/7/7.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSMessageData.h"
#import "EOSAccountName.h"

@interface EOSClaimrewardsMessageData :  NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *owner;

@end
