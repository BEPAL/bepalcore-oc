//
//  EOSAsset.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSAsset : NSObject

@property (assign, nonatomic) uint64_t amount;
@property (assign, nonatomic) uint32_t decimal;
@property (strong, nonatomic) NSString* unit;

- (instancetype)initWithString:(NSString*)value;
- (instancetype)initWithAmount:(uint64_t)amount Decimal:(uint32_t)decimal Unit:(NSString*)unit;
- (void)toByte:(NSMutableData*)stream;
- (void)parse:(NSData*)data :(NSUInteger*)index;
+ (EOSAsset*)toAsset:(NSData*)data :(NSUInteger*)index;
- (double)getValue;

@end
