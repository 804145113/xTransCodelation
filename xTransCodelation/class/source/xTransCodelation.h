//
//  xTransCodelation.h
//  xTransCodelation
//
//  Created by GXY on 15/7/28.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "NSString+URLEncode.h"
#import "HOStringInfoButton.h"
#import "HOStringFrameView.h"
#import "MsgWebViewController.h"
#import "SettingWindowController.h"
#import "BDTranslateManager.h"
#import "MsgPopverViewController.h"

@class xTransCodelation;

static xTransCodelation *sharedPlugin;
static NSString *enableKey = @"isEnable";

@interface xTransCodelation : NSObject <NSPopoverDelegate,NSAlertDelegate> {
    NSPopover *_stringPopover;
    SettingWindowController *settingPanel;
}

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

@end