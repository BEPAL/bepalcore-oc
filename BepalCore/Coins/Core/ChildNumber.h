//
//  ChildNumber.h
//  ectest
//
//  Created by 潘孝钦 on 2018/5/7.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildNumber : NSObject {
    uint32_t intPath;
}

@property(assign,nonatomic) BOOL hardened;

- (instancetype)initWithPath:(uint32_t)path;
- (instancetype)initWithPath:(uint32_t)path Hardened:(BOOL)isHardened;
- (uint32_t)getKeyPath;
- (NSData*)getPath;
- (NSData*)getPathNem;
- (NSData*)getPathBtm;
@end
