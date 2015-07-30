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
    NSString *apK = [[NSUserDefaults standardUserDefaults] objectForKey:KEYAPI];
    if (apK == nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"您还没有设置百度翻译的APIKey，步骤：Window - BDTranslation - 点击 - 更新，现在用的系统APIKey"];
        [alert runModal];
        apK = apiKey;
    }
    NSString *apiString = [NSString stringWithFormat:@"%@?client_id=%@&q=%@&from=auto&to=auto",translateUrl,apK,[text URLEncodeUsingEncoding:NSUTF8StringEncoding]];
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
            if ([contentJson objectForKey:@"error_msg"] != nil) {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:[NSString stringWithFormat:@"APIKey不存在：%@",[contentJson objectForKey:@"error_msg"]]];
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
