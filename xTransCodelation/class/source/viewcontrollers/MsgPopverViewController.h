//
//  MsgPopverViewController.h
//  xTransCodelation
//
//  Created by GXY on 15/7/29.
//  Copyright (c) 2015年 Tangxianhai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MsgPopverViewController : NSViewController
@property (unsafe_unretained) IBOutlet NSTextView *textView_msg;
@property (strong, nonatomic) NSPopover *popVer;

@property (strong, nonatomic) NSDictionary *msgDictionary;

@property (strong, nonatomic) NSString *msg;

@end
