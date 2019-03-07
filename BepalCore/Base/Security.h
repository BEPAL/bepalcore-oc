//
//  Security.h
//  BaseControl
//
//  Created by storecode  on 16-8-18.
//  Copyright © 2016年 mypxq. All rights reserved.
//

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

