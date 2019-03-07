//
//  EOSAccountName.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableData+Extend.h"
#import "NSData+Extend.h"

@interface EOSAccountName : NSObject

@property (strong, nonatomic) NSData *accountData;
@property (strong, nonatomic) NSString *accountName;
@property (assign, nonatomic) uint64_t accountValue;

- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithHex:(NSData*)name;
- (NSData*)accountNameToHex:(NSString*)name;
- (NSString*)hexToAccountName:(NSData*)hex;
+ (NSData*)getData:(NSString*)name;
+ (uint64_t)getValue:(NSString*)name;
+ (BOOL)isAccountName:(NSString*)name;

@end
