//
//  GXCOptional.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2019/2/19.
//  Copyright © 2019 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXCSerializable.h"

@interface GXCOptional : NSObject<GXCSerializable>

- (instancetype)initWithField:(id)field;

- (Boolean)isSet;

@end
