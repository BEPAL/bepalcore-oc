//
//  EOSNewMessageData.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSMessageData.h"
#import "EOSAccountName.h"
#import "EOSAuthority.h"

@interface EOSNewMessageData : NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *creator;
@property (strong, nonatomic) EOSAccountName *name;
@property (strong, nonatomic) EOSAuthority *owner;
@property (strong, nonatomic) EOSAuthority *active;

@end
