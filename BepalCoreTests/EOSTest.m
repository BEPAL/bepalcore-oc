//
//  EOSTest.m
//  BepalCoreTests
//
//  Created by 潘孝钦 on 2019/2/16.
//  Copyright © 2019 潘孝钦. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EosECKey.h"
#import "CoinFamily.h"
#import "Categories.h"
#import "EOSTransaction.h"
#import "EOSAction.h"
#import "EOSTxMessageData.h"
#import "ECSign.h"
#import "EOSBuyRamMessageData.h"
#import "EOSSellRamMessageData.h"
#import "EOSDelegatebwMessageData.h"
#import "EOSUnDelegatebwMessageData.h"
#import "EOSVoteProducerMessageData.h"
#import "EOSRegProxyMessageData.h"

@interface EOSTest : XCTestCase {
    EosECKey *ecKey;
    NSData *chainID;
}

@end

@implementation EOSTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    ecKey = [[EosECKey alloc] initWithPriKey:@"d0b864d15f3f57361317cee05beda29bdb39ae9a4a239d6f720317346751ca81".hexToData];
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

/// EOSIO transaction content packaging use cases
- (void)testTx {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function
    
    /// generate transaction
    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *sendto = @"bepal2|user_account"; // please write user account
    NSString *runtoken = @"eosio.token";
    NSString *tokenfun = @"transfer";

    // [2] determine the type of transaction
    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSTxMessageData *mdata = [EOSTxMessageData new];
    mdata.from = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.to = [[EOSAccountName alloc] initWithName:sendto];
    mdata.amount = [[EOSAsset alloc] initWithString:@"1.0000 EOS"];
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}


- (void)testBuyRam {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function

    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *sendto = @"bepal2|user_account"; // please write user account
    NSString *runtoken = @"eosio";
    NSString *tokenfun = @"buyram";

    // [2] determine the type of transaction
    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSBuyRamMessageData *mdata = [EOSBuyRamMessageData new];
    mdata.payer = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.receiver = [[EOSAccountName alloc] initWithName:sendto];
    mdata.quant = [[EOSAsset alloc] initWithString:@"1.0000 EOS"];
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}

- (void)testSellRam {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function

    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *runtoken = @"eosio";
    NSString *tokenfun = @"sellram";

    // [2] determine the type of transaction
    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSSellRamMessageData *mdata = [EOSSellRamMessageData new];
    mdata.account = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.bytes = 1024;
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}

- (void)testDelegatebw {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function

    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *runtoken = @"eosio";
    NSString *tokenfun = @"delegatebw";

    // [2] determine the type of transaction
    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSDelegatebwMessageData *mdata = [EOSDelegatebwMessageData new];
    mdata.from = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.receiver = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.stakeNetQuantity = [[EOSAsset alloc] initWithString:@"1.0000 EOS"];
    mdata.stakeCpuQuantity = [[EOSAsset alloc] initWithString:@"1.0000 EOS"];
    // @notes: 0: the authorizer cannot undelegatebw.
    //         1: the authorizer can undelegatebw.
    //         It is suggested to fill in 1
    mdata.transfer = 1;
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}

- (void)testUnDelegatebw {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function

    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    // [2] determine the type of transaction
    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *runtoken = @"eosio";
    NSString *tokenfun = @"undelegatebw";

    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSUnDelegatebwMessageData *mdata = [EOSUnDelegatebwMessageData new];
    mdata.from = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.receiver = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.stakeNetQuantity = [[EOSAsset alloc] initWithString:@"1.0000 EOS"];
    mdata.stakeCpuQuantity = [[EOSAsset alloc] initWithString:@"1.0000 EOS"];
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}

- (void)testRegProxy {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function

    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *runtoken = @"eosio";
    NSString *tokenfun = @"regproxy";

    // [2] determine the type of transaction
    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSRegProxyMessageData *mdata = [EOSRegProxyMessageData new];
    mdata.proxy = [[EOSAccountName alloc] initWithName:sendfrom];
    // set proxy  `isProxy = true`
    // off set proxy  `isProxy = false`
    mdata.isProxy = true;
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}

- (void)testVote {
    int block_num = 0;   // The most recent irreversible block # last_irreversible_block_num
    int ref_block_prefix = 0; // encode last_irreversible_block_id # last_irreversible_block_id[8-16]
    // ref https://github.com/EOSIO/eos/blob/master/libraries/chain/transaction.cpp set_reference_block function

    // [1] make block base info
    EOSTransaction *transaction = [EOSTransaction new];
    transaction.chainID = chainID;
    transaction.blockNum = block_num;
    transaction.blockPrefix = ref_block_prefix;
    transaction.netUsageWords = 0;
    transaction.kcpuUsage = 0;
    transaction.delaySec = 0;
    transaction.expiration = [[NSDate date] timeIntervalSince1970] + 60 * 60;

    NSString *sendfrom = @"bepal1|user_account"; // please write user account
    NSString *sendto = @"bepal2|user_account"; // please write user account
    // If the voting is conducted on behalf of others,
    // please fill in the account name of the agent here.
    // If the voting is conducted on an individual,  proxy = ""
    NSString *proxy = @"bepal3|user_account"; // please write user account
    NSString *runtoken = @"eosio";
    NSString *tokenfun = @"voteproducer";

    // [2] determine the type of transaction
    EOSAction *message = [EOSAction new];
    message.account = [[EOSAccountName alloc] initWithName:runtoken];
    message.name = [[EOSAccountName alloc] initWithName:tokenfun];
    [message.authorization addObject:[[EOSAccountPermission alloc] initWithString:sendfrom Permission:@"active"]];
    [transaction.actions addObject:message];

    // [3] content of the action of the account party
    EOSVoteProducerMessageData *mdata = [EOSVoteProducerMessageData new];
    mdata.voter = [[EOSAccountName alloc] initWithName:sendfrom];
    mdata.proxy = [[EOSAccountName alloc] initWithName:proxy];
    [mdata.producers addObject:[[EOSAccountName alloc] initWithName:sendto]];
    message.data = mdata;

    // [4] sign action
    ECSign *sign =[ecKey sign:transaction.getSignHash];
    [transaction.signature addObject:[sign encoding:true]];

    // [5] print broadcast data
    @try {
        NSLog(@"%@",transaction.toJson);
    } @catch (NSException *ex) {
        XCTAssertTrue(false);
    }

    // [6] check sign
    XCTAssertTrue([ecKey verify:transaction.getSignHash :sign]);
}

@end
