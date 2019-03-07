//
//  UserAccount.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXCUserAccount : NSObject {
    NSString *accountId;
    
    uint32_t space;
    uint32_t type;
    uint64_t instance;
}

- (instancetype)initWithId:(NSString*)aId;
- (NSData*)toByte;
- (NSString*)getId;

@end
