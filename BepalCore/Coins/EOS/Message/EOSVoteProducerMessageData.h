//
//  EOSVoteProducerMessageData.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAccountName.h"
#import "EOSMessageData.h"

@interface EOSVoteProducerMessageData : NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *voter;
@property (strong, nonatomic) EOSAccountName *proxy;
@property (strong, nonatomic) NSMutableArray<EOSAccountName*> *producers;

@end
