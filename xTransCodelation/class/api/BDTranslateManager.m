//
//  BDTranslateManager.m
//  xTransCodelation
//
//  Created by GXY on 15/7/28.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import "BDTranslateManager.h"
#import "Macro.h"

@implementation BDTranslateManager

+ (void)translateContent:(NSString *)text block:(void (^)(NSDictionary *))complete {
    NSString *currentApiKey = [[NSUserDefaults standardUserDefaults] objectForKey:KEYAPI];
    NSString *currentKeyFrom = [[NSUserDefaults standardUserDefaults] objectForKey:KEYFROM];
    NSString *apiString = nil;
    if (currentApiKey == nil || currentKeyFrom == nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"请完善有道翻译的配置信息，步骤：Window - BDTranslation - 点击 - 更新\n 现在用的系统配置!"];
        [alert runModal];
        apiString = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@",keyfrom,apiKey,[text URLEncodeUsingEncoding:NSUTF8StringEncoding]];
    } else {
        apiString = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@",currentKeyFrom,currentApiKey,[text URLEncodeUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURL *apiUrl = [NSURL URLWithString:apiString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiUrl];
    request.HTTPMethod = @"POST";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil || connectionError != nil) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"请检测你的网络状态是否良好！"];
            [alert runModal];
            return ;
        }
        NSDictionary *contentJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![contentJson isEqual:[NSNull null]]) {
            if ([[contentJson objectForKey:@"errorCode"] integerValue] != 0) {
                NSString *alertString = @"";
                switch ([[contentJson objectForKey:@"errorCode"] integerValue]) {
                    case 20:
                        alertString = @"要翻译的文本过长";
                        break;
                    case 30:
                        alertString = @"无法进行有效的翻译";
                        break;
                    case 40:
                        alertString = @"不支持的语言类型";
                        break;
                    case 50:
                        alertString = @"无效的key";
                        break;
                    default:
                        alertString = @"无词典结果，仅在获取词典结果生效";
                        break;
                }
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:[NSString stringWithFormat:@"%@",alertString]];
                [alert runModal];
            }
            else {
                if (complete) {
                    complete(contentJson);
                }
            }
        }
    }];
}

@end
