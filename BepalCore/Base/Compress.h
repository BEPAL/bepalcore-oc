//
//  Compress.h
//  test
//
//  Created by storecode  on 17-2-23.
//  Copyright © 2017年 mypxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Compress : NSObject

+ (NSData *)zipCompressData:(NSData *)uncompressedData;
+ (NSData *)unZipCompressData:(NSData *)compressedData;

@end
