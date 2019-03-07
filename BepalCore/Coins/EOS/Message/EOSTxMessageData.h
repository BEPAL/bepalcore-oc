//
//  EOSTxMessageData.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAsset.h"
#import "EOSAccountName.h"
#import "EOSMessageData.h"

@interface EOSTxMessageData : NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *from;
@property (strong, nonatomic) EOSAccountName *to;
@property (strong, nonatomic) EOSAsset *amount;
@property (strong, nonatomic) NSData *data;

@end
