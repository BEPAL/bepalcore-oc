//
//  SDKStaticPara.h
//  BepalSdk
//
//  Created by Hyq on 2018/7/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKStaticPara : NSObject

+ (SDKStaticPara*)getOrCreate;
- (id)getSynchronizedDeterministicKey;

@end
