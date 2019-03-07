//
//  ECSign.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECSign : NSObject

@property (nonatomic, retain) NSData* R;
@property (nonatomic, retain) NSData* S;
@property (nonatomic, assign) uint8_t V;

- (instancetype)initWithDataDer:(NSData*)data;
- (instancetype)initWithData:(NSData*)data;
- (instancetype)initWithBytes:(const void *)bytes V:(uint8_t)v;
- (instancetype)initWithData:(NSData*)data V:(uint8_t)v;
- (instancetype)initWithDataV:(NSData*)data;
- (instancetype)initWithR:(NSData*)r S:(NSData*)s V:(uint8_t)v;
- (NSData*)toDer;
- (NSData*)toData;
- (NSData*)toDataNoV;
- (NSString*)toHex;
- (NSData*)encoding:(Boolean)compressed;
- (uint8_t)getV:(Boolean)compressed;

@end
