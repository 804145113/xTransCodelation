//
//  MsgPopverViewController.m
//  xTransCodelation
//
//  Created by GXY on 15/7/29.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import "MsgPopverViewController.h"

@interface MsgPopverViewController ()
- (IBAction)closeAction:(NSButton *)sender;

@end

@implementation MsgPopverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 字体样式一
    NSDictionary *dic1 = @{
                           NSFontAttributeName:[NSFont systemFontOfSize:20.f],
                           NSForegroundColorAttributeName:[NSColor blackColor]
                           };
    // 字体样式二
    NSDictionary *dic2 = @{
                           NSFontAttributeName:[NSFont systemFontOfSize:20.f],
                           NSForegroundColorAttributeName:[NSColor blueColor]
                           };
    // 1.查询的内容
    NSString *query = [_msgDictionary objectForKey:@"query"];
    
    // 2.直译
    NSString *translation = [self arrayToString:[_msgDictionary objectForKey:@"translation"]];
    
    // 2.1拼接查询和直翻译文字
    NSMutableAttributedString * mQuery= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:\n%@",query,translation]];
    // 2.2设置样式
    [mQuery setAttributes:dic1 range:NSMakeRange(0, [query length] + 1)];
    [mQuery setAttributes:dic2 range:NSMakeRange([query length] + 1, [translation length])];
    
    [_textView_msg insertText:mQuery];
    
    // 3.解释说明
    NSArray *explains = [[_msgDictionary objectForKey:@"basic"] objectForKey:@"explains"];
    NSString *explain = [self arrayToString:explains];
    mQuery = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:\n%@",@"解释说明",explain]];
    [mQuery setAttributes:dic1 range:NSMakeRange(0, [@"解释说明" length] + 1)];
    [mQuery setAttributes:dic2 range:NSMakeRange([@"解释说明" length] + 1, [explain length])];
    [_textView_msg insertText:mQuery];
    
    // 4.网络释义
    NSArray *webs = [_msgDictionary objectForKey:@"web"];
    
    mQuery = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:\n",@"网络释义"]];
    [mQuery setAttributes:dic1 range:NSMakeRange(0, [@"网络释义" length] + 1)];
    [_textView_msg insertText:mQuery];
    
    [webs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSString *key = obj[@"key"];
        NSString *valueString = [self arrayToString:obj[@"value"]];
        NSMutableAttributedString *atr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:\n%@",key,valueString]];
        [atr1 setAttributes:dic1 range:NSMakeRange(0, [key length] + 1)];
        [atr1 setAttributes:dic2 range:NSMakeRange([key length] + 1, [valueString length])];
        [_textView_msg insertText:atr1];
    }];
}

- (NSString *)arrayToString:(NSArray *)ary {
    NSMutableString *rString = [NSMutableString new];
    [ary enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [rString appendFormat:@"%@\n",obj];
    }];
    return rString;
}

- (IBAction)closeAction:(NSButton *)sender {
    [self.popVer close];
}

@end
