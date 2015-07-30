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

static NSString *translateUrl = @"http://openapi.baidu.com/public/2.0/bmt/translate";
static NSString *apiKey = @"D07V0zTaFZilAr4f8F7FSGDG";

@interface BDTranslateManager : NSObject

+ (void)translateContent:(NSString *)text block:(void (^)(NSDictionary *jsonContent))complete;

@end
