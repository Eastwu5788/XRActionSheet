//
//  XRActionSheet.h
//  FreshMeet
//
//  Created by East_wu on 16/5/27.
//  Copyright © 2016年 鲜肉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRActionSheet;

typedef void(^actionSheetDidItemClick)(XRActionSheet *actionSheet,NSIndexPath *actionsheetIndexPath,NSString *title);

@interface XRActionSheet : UIView

/**
 *  初始化方法
 *
 *  @param cancelTitle 取消按钮的标题
 *  @param alertTitle  提示文本
 *  @param title       子标题
 */
+ (instancetype)actionSheetWithCancelTitle:(NSString *)cancelTitle alertTitle:(NSString *)alertTitle SubTitles:(NSString *)title,...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  点击某个子标题的回调
 */
- (void)setActionSheetDidItemClick:(actionSheetDidItemClick)block;
/**
 *  点击取消按钮的回调
 */
- (void)setActionSheetDismissItemClick:(actionSheetDidItemClick)block;

/**
 *  调起ActionSheet
 */
- (void)pop;

@end
