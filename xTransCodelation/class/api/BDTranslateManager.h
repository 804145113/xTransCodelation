//
//  BDTranslateManager.h
//  xTransCodelation
//
//  Created by GXY on 15/7/28.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "NSString+URLEncode.h"

static NSString *apiKey = @"2003963017";
static NSString *keyfrom = @"XcodeTranslate";

@interface BDTranslateManager : NSObject

+ (void)translateContent:(NSString *)text block:(void (^)(NSDictionary *jsonContent))complete;

@end
