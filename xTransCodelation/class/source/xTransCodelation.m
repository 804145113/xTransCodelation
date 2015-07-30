//
//  xTransCodelation.m
//  xTransCodelation
//
//  Created by GXY on 15/7/28.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import "xTransCodelation.h"

@interface xTransCodelation()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, assign) NSRange selectedStringRange;
@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, copy) NSString *selectedStringContent;
@property (nonatomic, strong) MsgPopverViewController *stringPopoverViewController;
@property (nonatomic, strong) MsgWebViewController *webViewController;
@property (nonatomic, strong) HOStringInfoButton *stringButton;
@property (nonatomic, strong) HOStringFrameView *stringFrameView;

@end

@implementation xTransCodelation

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;
        _selectedStringRange = NSMakeRange(NSNotFound, 0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
        if (!self.textView) {
            NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
            if ([firstResponder isKindOfClass:NSClassFromString(@"DVTSourceTextView")] && [firstResponder isKindOfClass:[NSTextView class]]) {
                self.textView = (NSTextView *)firstResponder;
            }
        }
        if (self.textView) {
            NSNotification *notification = [NSNotification notificationWithName:NSTextViewDidChangeSelectionNotification object:self.textView];
            [self selectionDidChange:notification];
            
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - View Initialization

- (HOStringInfoButton *)stringButton {
    if (!_stringButton) {
        _stringButton = [[HOStringInfoButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [_stringButton setTarget:self];
        [_stringButton setAction:@selector(showPopover:)];
    }
    return _stringButton;
}

- (HOStringFrameView *)stringFrameView {
    if (!_stringFrameView) {
        _stringFrameView = [[HOStringFrameView alloc] initWithFrame:NSZeroRect];
    }
    return _stringFrameView;
}

- (void)removeSelection {
    TNSLog
    [self dismissPopover];
    [self.stringButton removeFromSuperview];
    [self.stringFrameView removeFromSuperview];
    _selectedStringRange = NSNullRange;
    self.selectedStringContent = nil;
}

#pragma mark - Text Selection Handling

- (void)selectionDidChange:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:NSClassFromString(@"DVTSourceTextView")] && [[notification object] isKindOfClass:[NSTextView class]]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KEYENABLETRANSLATE] isEqualToString:@"1"]) {
            self.textView = (NSTextView *)[notification object];
            NSArray *selectedRanges = [self.textView selectedRanges];
            _selectedStringRange = [[selectedRanges objectAtIndex:0] rangeValue];
            if (_selectedStringRange.length >= 1) {
                NSString *text = self.textView.textStorage.string;
                self.selectedStringContent = [text substringWithRange:_selectedStringRange];
                
                // 根据Xcode主题计算颜色
                NSColor *backgroundColor = [self.textView.backgroundColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
                CGFloat r = 1.0; CGFloat g = 1.0; CGFloat b = 1.0;
                [backgroundColor getRed:&r green:&g blue:&b alpha:NULL];
                CGFloat backgroundLuminance = (r + g + b) / 3.0;
                NSColor *strokeColor = (backgroundLuminance > 0.5) ? [NSColor colorWithCalibratedWhite:0.5 alpha:1] : [NSColor colorWithCalibratedWhite:1.000 alpha:1];
                
                // 设置按钮标题
                NSString * aString = [NSString stringWithFormat:@"%@", @"译"];
                NSMutableDictionary * aAttributes = [NSMutableDictionary dictionary];
                NSMutableParagraphStyle * aStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                aStyle.alignment = NSCenterTextAlignment;
                [aAttributes setValue:(backgroundLuminance > 0.5) ? [NSColor whiteColor] : [NSColor blackColor]
                               forKey:NSForegroundColorAttributeName];
                [aAttributes setValue:[NSFont boldSystemFontOfSize:11] forKey:NSFontAttributeName];
                [aAttributes setValue:aStyle forKey:NSParagraphStyleAttributeName];
                NSAttributedString * aAttributedString = [[NSAttributedString alloc] initWithString:aString attributes:aAttributes];
                self.stringButton.attributedTitle = aAttributedString;
                self.stringButton.strokeColor = strokeColor;
                
                // 放置一个按钮
                NSRect selectionRectOnScreen = [self.textView firstRectForCharacterRange:self.selectedStringRange];
                NSRect selectionRectInWindow = [self.textView.window convertRectFromScreen:selectionRectOnScreen];
                NSRect selectionRectInView = [self.textView convertRect:selectionRectInWindow fromView:nil];
                
                CGFloat Width = [aAttributedString size].width + 14;
                NSRect buttonRect = NSMakeRect(NSMinX(selectionRectInView), NSMinY(selectionRectInView) - selectionRectInView.size.height - 2, Width, selectionRectInView.size.height);
                self.stringButton.frame = NSIntegralRect(buttonRect);
                
                [self.textView addSubview:self.stringButton];
                
                // 画所选文本内容的边线框
                self.stringFrameView.frame = NSInsetRect(NSIntegralRect(selectionRectInView), -1, -1);
                self.stringFrameView.color = strokeColor;
                [self.textView addSubview:self.stringFrameView];
            }
            else {
                [self removeSelection];
            }
        }
    }
}

- (void)showPopover:(id)sender {
    if(_selectedStringRange.location == NSNotFound || _selectedStringRange.length == 0) {
        [self dismissPopover];
        return;
    }
    [self dismissPopover];
    if(!_stringPopoverViewController) {
        _stringPopoverViewController = [[MsgPopverViewController alloc] initWithNibName:@"MsgPopverViewController" bundle:[NSBundle bundleForClass:[MsgPopverViewController class]]];
        _webViewController = [[MsgWebViewController alloc] initWithNibName:@"MsgWebViewController" bundle:[NSBundle bundleForClass:[MsgWebViewController class]]];
    }
    
    if(!_stringPopover) {
        _stringPopover = [[NSPopover alloc] init];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:KEYAPIMODEL] isEqualToString:@"1"]) {
        __block NSMutableAttributedString *attributedString = nil;
        _stringPopoverViewController.textView_msg.string = @"";
        [BDTranslateManager translateContent:_selectedStringContent block:^(NSDictionary *jsonContent) {
            NSArray *trans_result = jsonContent[@"trans_result"];
            [trans_result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n",obj[@"src"],obj[@"dst"]]];
                [attributedString addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, [attributedString length])];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0, [attributedString length])];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(0, [obj[@"src"] length])];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange([obj[@"src"] length] + 1, [obj[@"dst"] length] + 1)];
                [_stringPopoverViewController.textView_msg insertText:attributedString];
                _stringPopoverViewController.popVer = _stringPopover;
                _stringPopover.contentViewController = _stringPopoverViewController;
                _stringPopover.contentViewController = _stringPopoverViewController;
                _stringPopover.contentSize = _stringPopoverViewController.view.frame.size;
                _stringPopover.delegate = self;
                [_stringPopover showRelativeToRect:self.stringButton.bounds
                                            ofView:self.stringButton
                                     preferredEdge:NSMinYEdge];
            }];
        }];
    }
    else {
        NSString *translateString = [NSString stringWithFormat:@"%@%@",@"http://fanyi.baidu.com/?aldtype=16047#auto/zh/",[_selectedStringContent URLEncode]];
        [_webViewController.msgWebView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:translateString]]];
        _stringPopover.contentViewController = _webViewController;
        _stringPopover.contentSize = _webViewController.view.frame.size;
        _stringPopover.delegate = self;
        [_stringPopover showRelativeToRect:self.stringButton.bounds
                                    ofView:self.stringButton
                             preferredEdge:NSMinYEdge];
    }
}

- (void)popoverDidShow:(NSNotification *)notification {
    NSWindow *window = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    [window makeFirstResponder:nil];
}

- (void)dismissPopover {
    TNSLog
    if(_stringPopover) {
        [_stringPopover close];
    }
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"BDTranslation" action:@selector(doMenuAction:) keyEquivalent:@"r"];
        [actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        
        NSMenuItem *closeMenuItem = [[NSMenuItem alloc] initWithTitle:@"XtCloseOtherApps" action:@selector(docloseAction:) keyEquivalent:@"c"];
        [closeMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [closeMenuItem setTarget:self];
        [[menuItem submenu] addItem:closeMenuItem];
    }
}

- (void)docloseAction:(NSMenuItem *)mItem {
    NSAlert *alert = [NSAlert alertWithMessageText:@"-------------------警告------------------------------"
                                     defaultButton:@"正常退出"
                                   alternateButton:@"强制退出"
                                       otherButton:@"取消"
                         informativeTextWithFormat:@"该操作会强制关闭除Xcode以外的其他APP，请先保存所有工作！"];
    NSUInteger action = [alert runModal];
    //响应window的按钮事件
    if (action == NSAlertDefaultReturn)
        {
            NSWorkspace * ws = [NSWorkspace sharedWorkspace];
            NSArray * appsPids = [ws launchedApplications];
            for (NSDictionary * processInformation in appsPids)
            {
                NSString * appName = [processInformation objectForKey:@"NSApplicationName"];
                NSString * appIdentifier = [processInformation objectForKey:@"NSApplicationProcessIdentifier"];
                
                if (![appName isEqualToString:@"Xcode"] && ![appName isEqualToString:@"Finder"]) {
                    // -9表示 强制关闭，-15表示 正常退出
                    NSString *consie = [NSString stringWithFormat:@"kill -15 %@",appIdentifier];
                    const char *con = [consie cStringUsingEncoding:NSASCIIStringEncoding];
                    system(con);
                }
            }
        }
        else if (action == NSAlertAlternateReturn)
            {
//                NSLog(@"alternateButton clicked!");
                NSWorkspace * ws = [NSWorkspace sharedWorkspace];
                NSArray * appsPids = [ws launchedApplications];
                for (NSDictionary * processInformation in appsPids)
                {
                    NSString * appName = [processInformation objectForKey:@"NSApplicationName"];
                    NSString * appIdentifier = [processInformation objectForKey:@"NSApplicationProcessIdentifier"];
                    
                    if (![appName isEqualToString:@"Xcode"] && ![appName isEqualToString:@"Finder"]) {
                        // -9表示 强制关闭，-15表示 正常退出
                        NSString *consie = [NSString stringWithFormat:@"kill -9 %@",appIdentifier];
                        const char *con = [consie cStringUsingEncoding:NSASCIIStringEncoding];
                        system(con);
                    }
                }
            }
        else if (action == NSAlertOtherReturn)
            {
//                NSLog(@"cancelButton clicked!");
            }
}

- (void)doMenuAction:(NSMenuItem *)mItem
{
    [self showSettingPanel:nil];
}

- (void)showSettingPanel:(NSNotification *)noti {
    settingPanel = [[SettingWindowController alloc] initWithWindowNibName:@"SettingWindowController"];
    [settingPanel showWindow:settingPanel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
