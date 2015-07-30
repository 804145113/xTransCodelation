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
    // Do view setup here.
}

- (IBAction)closeAction:(NSButton *)sender {
    [self.popVer close];
}

@end
