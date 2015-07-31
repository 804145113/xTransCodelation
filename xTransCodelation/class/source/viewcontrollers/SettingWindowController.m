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
@property (weak) IBOutlet NSTextField *textField_keyfrom;
@property (weak) IBOutlet NSButton *buttonOpenUrl;
@property (weak) IBOutlet NSButton *button_enableTranslate;
@property (weak) IBOutlet NSComboBox *comboBoxmodel;

#pragma mark - Action

// 是否开启有道翻译
- (IBAction)actionBeginTranslate:(NSButton *)sender;

// 打开有道API开发平台网站
- (IBAction)actionOpenUrlBaiDuApi:(NSButton *)sender;

// 设置更新APIKEY,有道翻译API非收费，每小时/1000次！
- (IBAction)actionUpdatApiKey:(NSButton *)sender;

// 设置翻译的模式 - 百度网页或是有道网页
- (IBAction)actionSelectTranslation:(NSComboBox *)sender;

@end

@implementation SettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    uDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置是否开启翻译
    if ([uDefaults objectForKey:KEYENABLETRANSLATE] == nil || [[uDefaults objectForKey:KEYENABLETRANSLATE] isEqualToString:@"0"]) {
        [_button_enableTranslate setState:0];
        _comboBoxmodel.hidden = YES;
        _buttonOpenUrl.hidden = YES;
    }
    else {
        [_button_enableTranslate setState:1];
        _comboBoxmodel.hidden = NO;
        _buttonOpenUrl.hidden = NO;
    }
    // 2.检测是否有APIkey 和 keyfrom
    if ([uDefaults objectForKey:KEYAPI] == nil) {
        [_textField_apiKey setStringValue:@""];
    }
    else {
        [_textField_apiKey setStringValue:[uDefaults objectForKey:KEYAPI]];
    }
    
    if ([uDefaults objectForKey:KEYFROM] == nil) {
        [_textField_keyfrom setStringValue:@""];
    }
    else {
        [_textField_keyfrom setStringValue:[uDefaults objectForKey:KEYFROM]];
    }
    
    // 3.设置翻译模式 默认为SDK查询方式
    if ([uDefaults objectForKey:KEYAPIMODEL] == nil) {
        [uDefaults setObject:@"0" forKey:KEYAPIMODEL];
        [_comboBoxmodel selectItemAtIndex:0];
    }
    else if ([[uDefaults objectForKey:KEYAPIMODEL] isEqualToString:@"1"]) {
        [_comboBoxmodel selectItemAtIndex:1];
    }
    else {
        [_comboBoxmodel selectItemAtIndex:2];
    }
}

- (IBAction)actionBeginTranslate:(NSButton *)sender {
    if ([uDefaults objectForKey:KEYENABLETRANSLATE] == nil || [[uDefaults objectForKey:KEYENABLETRANSLATE] isEqualToString:@"0"]) {
        [uDefaults setObject:@"1" forKey:KEYENABLETRANSLATE];
        [_button_enableTranslate setState:1];
        [_comboBoxmodel setHidden:NO];
        [_buttonOpenUrl setHidden:NO];
    }
    else {
        [uDefaults setObject:@"0" forKey:KEYENABLETRANSLATE];
        [_button_enableTranslate setState:0];
        [_comboBoxmodel setHidden:YES];
        [_buttonOpenUrl setHidden:YES];
    }
}

- (IBAction)actionOpenUrlBaiDuApi:(NSButton *)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fanyi.youdao.com/openapi?path=data-mode"]];
}

- (IBAction)actionUpdatApiKey:(NSButton *)sender {
    if ([[_textField_apiKey stringValue] isEqualToString:@""] || [[_textField_keyfrom stringValue] isEqualToString:@""]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"您的信息填写不正确！"];
        [alert runModal];
        return;
    }
    [uDefaults setObject:[_textField_apiKey stringValue] forKey:KEYAPI];
    [uDefaults setObject:[_textField_keyfrom stringValue] forKey:KEYFROM];
}

- (IBAction)actionSelectTranslation:(NSComboBox *)sender {
    if ([sender indexOfSelectedItem] == 0) {
        [uDefaults setObject:@"0" forKey:KEYAPIMODEL];
    }
    else if ([sender indexOfSelectedItem] == 1) {
        [uDefaults setObject:@"1" forKey:KEYAPIMODEL];
    }
    else if ([sender indexOfSelectedItem] == 2) {
        [uDefaults setObject:@"2" forKey:KEYAPIMODEL];
    }
}
@end
