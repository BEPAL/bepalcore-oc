/*
 * Copyright (c) 2018-2019, BEPAL
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the University of California, Berkeley nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <XCTest/XCTest.h>
#import "GXCECKey.h"
#import "CoinFamily.h"
#import "Categories.h"
#import "GXCTransaction.h"
#import "ECSign.h"
#import "GXCTxOperation.h"

@interface GXCTest : XCTestCase {
    GXCECKey *ecKey;
    NSData *chainID;
}

@end

@implementation GXCTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    ecKey = [[GXCECKey alloc] initWithPriKey:[@"5K1yv2ghXNEGPzuSRYxY4hTYsjoftSSFSKgbaqwZ68RvnyoBgYK".base58checkToData subdataWithRange:NSMakeRange(1, 32)]];
    // rpc service localhost:8080/v1/chain/get_info  -> chain_id
    chainID = @"aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906".hexToData;
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

- (void)testTx {
    int block_num = 0;
    int ref_block_prefix = 0;
    
    GXCTransaction *tx = [GXCTransaction new];
    tx.chainID = chainID;
    tx.blockNum = block_num;
    tx.blockPrefix = ref_block_prefix;
    tx.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"1.2.1207";
    NSString *sendto = @"1.2.695";
    NSString *runasset = @"1.3.1";
    
    GXCTxOperation *txop = [GXCTxOperation new];
    txop.amount = [[GXCAssetAmount alloc] initWithAmount:10000 Asset:runasset];
    txop.fee = [[GXCAssetAmount alloc] initWithAmount:2000 Asset:runasset];
    txop.from = [[GXCUserAccount alloc] initWithId:sendfrom];
    txop.to = [[GXCUserAccount alloc] initWithId:sendto];
    
    GXCECKey *key1 =[[GXCECKey alloc] initWithPubKeyString:@"GXC6m2KavJGPwxRTrqZTXd8ZspVEajoy8CDLWe5qEhJsbKPoLkxiT"];
    
    NSData *nonce = [NSData randomWithSize:8];
    txop.memo = [[GXCMemo alloc] initWithKeyFrom:ecKey To:key1 Nonce:nonce];
    [txop.memo encryptWithKey:ecKey Message:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [tx.operations addObject:txop];
    
    [tx sign:ecKey];
    
    @try {
        NSLog(@"%@",tx.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }
    
    XCTAssertTrue([ecKey verify:tx.getSignHash :[[ECSign alloc] initWithDataV:tx.signature[0]]]);
}

@end
