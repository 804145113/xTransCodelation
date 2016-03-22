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
    // 1.查询的内容
    NSString *query = [_msgDictionary objectForKey:@"query"];
    if (query.length > 0) {
        NSMutableAttributedString * mQuery= [[NSMutableAttributedString alloc] initWithString:query attributes:@{
                                                                                                                 NSFontAttributeName:[NSFont boldSystemFontOfSize:18.f],
                                                                                                                 NSForegroundColorAttributeName:[NSColor blackColor]
                                                                                                                 }];
        [_textView_msg insertText:mQuery];
    }
    
    // 2.音标
    NSString *pre_phonetic = [[_msgDictionary objectForKey:@"basic"] objectForKey:@"phonetic"];
    if (pre_phonetic.length > 0) {
        NSString *phonetic = [[@"|" stringByAppendingString:pre_phonetic] stringByAppendingString:@"|"];
        NSMutableAttributedString * mPhonetic = [[NSMutableAttributedString alloc] initWithString:phonetic attributes:@{
                                                                                                                        NSFontAttributeName:[NSFont fontWithName:@"Consolas" size:13.f],
                                                                                                                        NSForegroundColorAttributeName:[NSColor grayColor]
                                                                                                                        }];
        [_textView_msg insertText:@"\t"];
        [_textView_msg insertText:mPhonetic];
    }

    // 3.解释说明
    NSArray *explains = [[_msgDictionary objectForKey:@"basic"] objectForKey:@"explains"];
    NSString *explain = [self arrayToString:explains];
    if (explain.length > 0) {
        NSMutableAttributedString * mExplain = [[NSMutableAttributedString alloc] initWithString:explain attributes:@{
                                                                                                                      NSFontAttributeName:[NSFont systemFontOfSize:14.f],
                                                                                                                      NSForegroundColorAttributeName:[NSColor blackColor]
                                                                                                                      }];
        
        [_textView_msg insertText:@"\n"];
        [_textView_msg insertText:mExplain];
    }

    // 4.网络释义
    NSArray *webs = [_msgDictionary objectForKey:@"web"];
    if (webs.count > 0) {
        __block NSMutableString *webString = [[NSMutableString alloc] initWithString:@"网络释义:"];
        [webs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSString *key = obj[@"key"];
            NSString *valueString = [obj[@"value"] firstObject];
            if (key.length > 0 && valueString.length > 0) {
                [webString appendString:@"\n"];
                [webString appendString:[NSString stringWithFormat:@"%ld. %@:%@",idx,key,valueString]];
            }
        }];
        
        NSMutableAttributedString * mWebString = [[NSMutableAttributedString alloc] initWithString:webString attributes:@{
                                                                                                                      NSFontAttributeName:[NSFont systemFontOfSize:14.f],
                                                                                                                      NSForegroundColorAttributeName:[NSColor blackColor]
                                                                                                                      }];
        [mWebString setAttributes:@{
                                    NSFontAttributeName:[NSFont boldSystemFontOfSize:18.f],
                                    NSForegroundColorAttributeName:[NSColor darkGrayColor]
                                    }
                            range:NSMakeRange(0, [@"网络释义:" length] + 1)];

        [_textView_msg insertText:@"\n"];
        [_textView_msg insertText:mWebString];
    }
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
