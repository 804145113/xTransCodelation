//
//  SettingWindowController.m
//  xTransCodelation
//
//  Created by GXY on 15/7/29.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import "SettingWindowController.h"

@interface SettingWindowController ()

#pragma mark - IBOutlet
@property (weak) IBOutlet NSTextField *textField_apiKey;
@property (weak) IBOutlet NSButton *button_enableTranslate;
@property (weak) IBOutlet NSMatrix *matrix_model;


#pragma mark - Action

// 是否开启百度翻译
- (IBAction)actionBeginTranslate:(NSButton *)sender;

// 打开百度API开发平台网站
- (IBAction)actionOpenUrlBaiDuApi:(NSButton *)sender;

// 设置更新APIKEY,百度翻译API非收费，每小时/1000次！
- (IBAction)actionUpdatApiKey:(NSButton *)sender;

// 设置查询翻译模式
- (IBAction)actionModel:(NSMatrix *)sender;

@end

@implementation SettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    uDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置是否开启翻译
    if ([uDefaults objectForKey:KEYENABLETRANSLATE] == nil || [[uDefaults objectForKey:KEYENABLETRANSLATE] isEqualToString:@"0"]) {
        [_button_enableTranslate setState:0];
    }
    else {
        [_button_enableTranslate setState:1];
    }
    // 2.检测是否有APIkey
    if ([uDefaults objectForKey:KEYAPI] == nil) {
        [_textField_apiKey setStringValue:@""];
    }
    else {
        [_textField_apiKey setStringValue:[uDefaults objectForKey:KEYAPI]];
    }
    
    // 3.设置翻译模式 默认为SDK查询方式
    if ([uDefaults objectForKey:KEYAPIMODEL] == nil) {
        [uDefaults setObject:@"0" forKey:KEYAPIMODEL];
        [_matrix_model setState:1 atRow:0 column:0];
    }
    else if ([[uDefaults objectForKey:KEYAPIMODEL] isEqualToString:@"0"]) {
        [_matrix_model setState:1 atRow:0 column:0];
    }
    else {
        [_matrix_model setState:1 atRow:1 column:0];
    }
}

- (IBAction)actionBeginTranslate:(NSButton *)sender {
    if ([uDefaults objectForKey:KEYENABLETRANSLATE] == nil || [[uDefaults objectForKey:KEYENABLETRANSLATE] isEqualToString:@"0"]) {
        [uDefaults setObject:@"1" forKey:KEYENABLETRANSLATE];
        [_button_enableTranslate setState:1];
    }
    else {
        [uDefaults setObject:@"0" forKey:KEYENABLETRANSLATE];
        [_button_enableTranslate setState:0];
    }
}

- (IBAction)actionOpenUrlBaiDuApi:(NSButton *)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://developer.baidu.com/console#app/6503102"]];
}

- (IBAction)actionUpdatApiKey:(NSButton *)sender {
    if ([[_textField_apiKey stringValue] isEqualToString:@""]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"apikey不能为空！"];
        [alert runModal];
        return;
    }
    [uDefaults setObject:[_textField_apiKey stringValue] forKey:KEYAPI];
}

- (IBAction)actionModel:(NSMatrix *)sender {
    if ([[uDefaults objectForKey:KEYAPIMODEL] isEqualToString:@"0"]) {
        [uDefaults setObject:@"1" forKey:KEYAPIMODEL];
        [_matrix_model setState:1 atRow:1 column:0];
    }
    else {
        [uDefaults setObject:@"0" forKey:KEYAPIMODEL];
        [_matrix_model setState:1 atRow:0 column:0];
    }
}
@end
