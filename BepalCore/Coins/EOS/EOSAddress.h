//
//  EOSAddress.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/10.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSAddress : NSObject {
    NSData *pubkey;
}

- (instancetype)init:(NSData*)pubKey;
- (NSString*)toAddress;
+ (NSData*)toPubKey:(NSString*)address;

@end
