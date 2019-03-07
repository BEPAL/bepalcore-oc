//
//  PrivateKeyTest.m
//  BepalCoreTests
//
//  Created by 潘孝钦 on 2019/2/16.
//  Copyright © 2019 潘孝钦. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoinFamily.h"
#import "Categories.h"
#import "EOSAddress.h"
#import "GXCAddress.h"

@interface PrivateKeyTest : XCTestCase{
    NSData *seed;
    NSString *message;
}

@end

@implementation PrivateKeyTest

- (void)setUp {
//    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSMutableArray<NSString*> *data = [NSMutableArray new];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];
    [data addObject:@"Bepal"];

    seed = [MnemonicCode toSeed:data withPassphrase:@""];
    NSLog(@"seed hex: [%@]",seed.hexString);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testEos {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    EosDeterministicKey *rootKey = [[EosDeterministicKey alloc] initWithSeed:seed];
    
    /// build key chain
    // 44'/194'/0'/0/0
    NSMutableArray *path = [NSMutableArray new];
    [path addObject:[[ChildNumber alloc] initWithPath:44 Hardened:YES]];
    [path addObject:[[ChildNumber alloc] initWithPath:194 Hardened:YES]];
    [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:YES]];
    [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    
    // 44'/194'/0'
    NSMutableArray *path1 = [NSMutableArray new];
    [path1 addObject:[[ChildNumber alloc] initWithPath:44 Hardened:YES]];
    [path1 addObject:[[ChildNumber alloc] initWithPath:194 Hardened:YES]];
    [path1 addObject:[[ChildNumber alloc] initWithPath:0 Hardened:YES]];
    
    // 0/0
    NSMutableArray *path2 = [NSMutableArray new];
    [path2 addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    [path2 addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    /// build end
    
    
    // this's not standard bip32
    NSString *xpub = [[rootKey derive:path1] toStandardXPub:0x043587CF];
    EosDeterministicKey *rootxpub = [[EosDeterministicKey alloc] initWithStandardKey:xpub.base58checkToData XPrvHead:0x04358394];
    
    // ec key
    EosECKey *publicKey = [[rootxpub derive:path2] toECKey];
    EosECKey *privateKey = [[rootKey derive:path] toECKey];
    // check
    XCTAssertTrue([privateKey.publicKeyAsHex isEqualToString:publicKey.publicKeyAsHex]);
    
    
    // sign message
    NSData *msg = [SHAHash sha2256:[message dataUsingEncoding:NSUTF8StringEncoding]];
    ECSign *sign = [privateKey sign:msg];
    // check sign
    XCTAssertTrue([publicKey verify:msg :sign]);
    
    // public key
    // EOS5eyq829Bi8Cmg99WGvVPNVWqq2Rc5kYRXxtxjTP2RAisom1GHa
    NSLog(@"EOS pubkey: [%@]",publicKey.toPubblicKeyString);
    // private key
    // 5HvZEPkiAur49Tb4k9nYvagAYEmobsiFtmegzSeuWHWke2JCL9K
    NSLog(@"EOS prvkey: [%@]",privateKey.toWif);
}

- (void)testGXC {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    GXCDeterministicKey *rootKey = [[GXCDeterministicKey alloc] initWithSeed:seed];
    
    /// build key chain
    // 44'/2303'/0'/0/0
    NSMutableArray *path = [NSMutableArray new];
    [path addObject:[[ChildNumber alloc] initWithPath:44 Hardened:YES]];
    [path addObject:[[ChildNumber alloc] initWithPath:2303 Hardened:YES]];
    [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:YES]];
    [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    
    // 44'/2303'/0'
    NSMutableArray *path1 = [NSMutableArray new];
    [path1 addObject:[[ChildNumber alloc] initWithPath:44 Hardened:YES]];
    [path1 addObject:[[ChildNumber alloc] initWithPath:2303 Hardened:YES]];
    [path1 addObject:[[ChildNumber alloc] initWithPath:0 Hardened:YES]];
    
    // 0/0
    NSMutableArray *path2 = [NSMutableArray new];
    [path2 addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    [path2 addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
    /// build end
    
    
    // this's not standard bip32
    NSString *xpub = [[rootKey derive:path1] toStandardXPub:0x043587CF];
    GXCDeterministicKey *rootxpub = [[GXCDeterministicKey alloc] initWithStandardKey:xpub.base58checkToData XPrvHead:0x04358394];
    
    // ec key
    GXCECKey *publicKey = [[rootxpub derive:path2] toECKey];
    GXCECKey *privateKey = [[rootKey derive:path] toECKey];
    // check
    XCTAssertTrue([privateKey.publicKeyAsHex isEqualToString:publicKey.publicKeyAsHex]);
    
    
    // sign message
    NSData *msg = [SHAHash sha2256:[message dataUsingEncoding:NSUTF8StringEncoding]];
    ECSign *sign = [privateKey sign:msg];
    // check sign
    XCTAssertTrue([publicKey verify:msg :sign]);
    
    // public key
    // GXC86frDL7Qw5hj6TV1qoCfoBbnQNXHnHxAX45VAMRN8VrMp8egr1
    NSLog(@"GXC pubkey: [%@]",publicKey.toPubblicKeyString);
    // private key
    // 5K1yv2ghXNEGPzuSRYxY4hTYsjoftSSFSKgbaqwZ68RvnyoBgYK
    NSLog(@"GXC prvkey: [%@]",privateKey.toWif);
}

@end
