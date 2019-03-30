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

#import "ErrorTool.h"

@implementation ErrorTool

+ (void)checkArgument:(BOOL)bo Mess:(NSString*)mess {
    if (!bo) {
        @throw [[NSException alloc] initWithName:@"Argument Exception" reason:mess userInfo:nil];
    }
}

+ (void)checkArgument:(BOOL)bo Mess:(NSString*)mess Log:(NSString*)log {
    if (!bo) {
        @throw [[NSException alloc] initWithName:@"Argument Exception" reason:[NSString stringWithFormat:@"mess:%@ log:%@",mess,log] userInfo:nil];
    }
}

+ (void)checkNotNull:(id)data {
    if (data == nil) {
        @throw [[NSException alloc] initWithName:@"NULL Exception" reason:@"空的对象" userInfo:nil];
    }
}

+ (void)throwMessage:(NSString*)mess {
    @throw [[NSException alloc] initWithName:@"Data Exception" reason:mess userInfo:nil];
}

+ (void)unimplementedMethod {
    @throw [[NSException alloc] initWithName:@"Unimplemented Method Exception" reason:@"未实现该方法" userInfo:nil];
}

@end
