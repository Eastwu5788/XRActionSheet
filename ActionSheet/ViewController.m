//
//  ViewController.m
//  ActionSheet
//
//  Created by East_wu on 16/9/6.
//  Copyright © 2016年 East_wu. All rights reserved.
//

#import "ViewController.h"
#import "XRActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    XRActionSheet *actionSheet = [XRActionSheet actionSheetWithCancelTitle:@"取消" alertTitle:@"这是提示文字" SubTitles:@"点赞",@"举报", nil];
    
    [actionSheet setActionSheetDidItemClick:^(XRActionSheet *actionSheet, NSIndexPath *actionsheetIndexPath, NSString *title) {
        NSLog(@"row:%ld title:%@",(long)actionsheetIndexPath.row,title);
    }];
    
    [actionSheet setActionSheetDismissItemClick:^(XRActionSheet *actionSheet, NSIndexPath *actionsheetIndexPath, NSString *title) {
        NSLog(@"取消按钮点击");
    }];
    
    [actionSheet pop];
}

@end
