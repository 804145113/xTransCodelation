//
//  MsgWebViewController.m
//  xTransCodelation
//
//  Created by GXY on 15/7/29.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import "MsgWebViewController.h"

@interface MsgWebViewController ()

@end

@implementation MsgWebViewController

- (void)viewWillAppear {
    [super viewWillAppear];
    // 加载数据
    [self.msgWebView.mainFrame loadHTMLString:self.htmlString baseURL:nil];
}

@end
