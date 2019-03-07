//
//  GXCAsset.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXCAsset : NSObject 

@property (strong, nonatomic) NSString *assetId;

@property (assign, nonatomic) uint32_t space;
@property (assign, nonatomic) uint32_t type;
@property (assign, nonatomic) uint64_t instance;

- (instancetype)initWithId:(NSString*)aId;
- (NSString*)getId;

@end
