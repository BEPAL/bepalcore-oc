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

#import <Foundation/Foundation.h>
#import "GXCBaseOperation.h"
#import "GXCECKey.h"

static int GXC_DEFAULT_EXPIRATION_TIME = 30;

static NSString *GXC_KEY_EXPIRATION = @"expiration";
static NSString *GXC_KEY_SIGNATURES = @"signatures";
static NSString *GXC_KEY_OPERATIONS = @"operations";
static NSString *GXC_KEY_REF_BLOCK_NUM = @"ref_block_num";
static NSString *GXC_KEY_REF_BLOCK_PREFIX = @"ref_block_prefix";

@interface GXCTransaction : NSObject

@property (strong, nonatomic) NSData *chainID;
@property (assign, nonatomic) uint64_t expiration;
@property (assign, nonatomic) uint16_t blockNum;
@property (assign, nonatomic) uint32_t blockPrefix;

@property (strong, nonatomic) NSMutableArray<GXCBaseOperation*> *operations;
@property (strong, nonatomic) GXCExtensions *extensions;
@property (strong, nonatomic) NSMutableArray *signature;

- (NSDictionary*)toJson;
- (NSData*)sign:(GXCECKey*)key;
- (NSData*)getTxID;
- (NSData*)getSignHash;

@end
