/*
 * Copyright (c) 2016-2019, BEPAL
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

@interface Security : NSObject
+(NSString*)RsaEncrypt:(NSString*)content PublicKey:(NSString*)publickey;
+(NSData*)RsaEncryptByData:(NSData*)content PublicKey:(NSData*)publickey;
+(NSString*)RsaDecrypt:(NSString*)content PrivateKey:(NSString*)privatekey Password:(NSString*)pwd;
+(NSString*)GetMD5:(NSString*)content;
+(NSData*)GetMD5Data:(NSData*)content;
+(NSData*)GetSHA1Data:(NSData*)content;
+(NSString*)DesEncrypt:(NSString*)content Key:(NSString*)key;
+(NSString*)DesEncrypt:(NSString*)content Key:(NSString*)key IV:(Byte[])iv;
+(NSString*)DesDecrypt:(NSString*)content Key:(NSString*)key;
+(NSString*)DesDecrypt:(NSString*)content Key:(NSString*)key IV:(Byte[])iv;
+(NSData*)DesDecryptData:(NSData*)data Key:(NSData*)keyData IV:(Byte[])iv;
+(NSData*)DesEncryptData:(NSData*)data Key:(NSData*)keyData IV:(Byte[])iv;
+(NSString*)AesEncrypt:(NSString*)content Key:(NSString*)key;
+(NSData*)AesEncryptData:(NSData*)data Key:(NSData*)key;
+(NSData*)AesEncryptCBCData:(NSData*)data Key:(NSData*)key IV:(NSData*)iv;
+(NSString*)AesDecrypt:(NSString*)content Key:(NSString*)key;
+(NSData*)AesDecrypData:(NSData*)data Key:(NSData*)key;
+(NSData*)AesDecrypCBCData:(NSData*)data Key:(NSData*)key IV:(NSData*)iv;
+(NSString*)toBase64FromString:(NSString*)content;
+(NSString*)toBase64FromNSData:(NSData*)content;
+(NSString*)fromBase64ToString:(NSString*)content;
+(NSData*)fromBase64ToNSData:(NSString*)content;
+(NSString*)toHexString:(NSData*)data;
+(NSData*)fromHexString:(NSString*)str;
@end

