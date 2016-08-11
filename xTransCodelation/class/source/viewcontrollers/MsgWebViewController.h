//
//  MsgWebViewController.h
//  xTransCodelation
//
//  Created by GXY on 15/7/29.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface MsgWebViewController : NSViewController

@property (weak) NSString *htmlString;
@property (weak) IBOutlet WebView *msgWebView;

@end
