//
//  EOSMessage.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSMessageData.h"
#import "EOSAccountPermission.h"

@interface EOSAction : NSObject

@property (strong, nonatomic) EOSAccountName *account;
@property (strong, nonatomic) EOSAccountName *name;
@property (strong, nonatomic) NSMutableArray<EOSAccountPermission*> *authorization;
@property (strong, nonatomic) id<EOSMessageData> data;

- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;

@end
