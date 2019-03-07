//
//  MnemonicCode.h
//  ectest
//
//  Created by 潘孝钦 on 2018/5/17.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MnemonicCode : NSObject {
    NSArray *wordList;
}
//并非单例只是普通init
//+ (instancetype)sharedInstance;

- (instancetype)initWithWordList:(NSArray *)list;

- (NSArray *)toMnemonicArray:(NSData *)data;

- (NSString *)toMnemonicWithArray:(NSArray *)a;

- (NSString *)toMnemonic:(NSData *)data;

- (NSData *)toEntropy:(NSString *)code;

- (BOOL)check:(NSString *)code;

+ (NSData *)toSeed:(NSArray *)code withPassphrase:(NSString *)passphrase;

@end
