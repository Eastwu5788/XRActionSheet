//
//  XRActionSheet.m
//  FreshMeet
//
//  Created by East_wu on 16/5/27.
//  Copyright © 2016年 鲜肉. All rights reserved.
//

#import "XRActionSheet.h"


#define force_inline __inline__ __attribute__((always_inline))


static force_inline CGFloat kScreenWidth() {
    return CGRectGetWidth([[UIScreen mainScreen] bounds]);
}

static force_inline CGFloat kScreenHeight() {
    return CGRectGetHeight([[UIScreen mainScreen] bounds]);
}

static force_inline NSString * kValidStr(NSString *str) {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [str stringByTrimmingCharactersInSet:set];
}

static force_inline CGFloat kLineHeight() {
    return 1/[UIScreen mainScreen].scale;
}

static force_inline UIColor * XRHex(rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@interface XRActionSheet () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *subTitlesArray;
@property (nonatomic, copy)   NSString       *cancelTitle;
/**
 *  背景视图
 */
@property (nonatomic, weak)   UIView         *backgroundView;
/**
 *  内容视图
 */
@property (nonatomic, weak)   UITableView    *tableView;

@property (nonatomic, copy) NSString *alertTitle;
@end

@implementation XRActionSheet {
    actionSheetDidItemClick _clickBlock;
    actionSheetDidItemClick _dismissBlock;
}

+ (instancetype)actionSheetWithCancelTitle:(NSString *)cancelTitle alertTitle:(NSString *)alertTitle SubTitles:(NSString *)title,...NS_REQUIRES_NIL_TERMINATION {
    XRActionSheet *sheet = [[XRActionSheet alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth(), kScreenHeight())];
    sheet.cancelTitle = cancelTitle;
    sheet.alertTitle = alertTitle;
    NSString *subTitle;
    va_list argumentList;
    if(title) {
        [sheet.subTitlesArray addObject:title];
        va_start(argumentList, title);
        while((subTitle = va_arg(argumentList, id))) {
            NSString *tit = [subTitle copy];
            if([tit isKindOfClass:[NSString class]] && tit.length != 0) {
                [sheet.subTitlesArray addObject:tit];
            }
        }
        va_end(argumentList);
    }
    return sheet;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self backgroundView];
    }
    return self;
}

#pragma mark - setter
- (void)setActionSheetDidItemClick:(actionSheetDidItemClick)block {
    _clickBlock = block;
}

- (void)setActionSheetDismissItemClick:(actionSheetDidItemClick)block {
    _dismissBlock = block;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.subTitlesArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:kScreenWidth() > 320 ? 16 : 15];
    if(indexPath.section == 0) {
        NSString *subTitle = self.subTitlesArray[indexPath.row];
        if ([subTitle containsString:@"删除"] || [subTitle containsString:@"delete"]) {
            cell.textLabel.textColor = XRHex(0xff5a5f);
        } else {
            cell.textLabel.textColor = XRHex(0x333333);
        }
        cell.textLabel.text = [self.subTitlesArray objectAtIndex:indexPath.row];
    }else {
        cell.textLabel.text = self.cancelTitle;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth() > 320 ? 55 : 50.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if ([kValidStr(self.alertTitle) length] == 0) {
            return nil;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth(), 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kValidStr(self.alertTitle)];
        [string addAttribute:NSForegroundColorAttributeName value:[[UIColor blackColor] colorWithAlphaComponent:0.5] range:NSMakeRange(0, self.alertTitle.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kScreenWidth() > 320 ? 14 : 13] range:NSMakeRange(0, self.alertTitle.length)];
        [string addAttribute:NSKernAttributeName value:@(0.2) range:NSMakeRange(0, self.alertTitle.length)];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.lineSpacing = 3;
        [string addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, self.alertTitle.length)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, kScreenWidth() - 30 * 2, 52)];
        label.attributedText = string;
        label.numberOfLines = 0;
        [view addSubview:label];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 60 - kLineHeight(), kScreenWidth(), kLineHeight());
        [view.layer addSublayer:layer];
        layer.backgroundColor = XRHex(0xcccccc).CGColor;
        return view;
        
        
       // return label;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth(), 5)];
        view.backgroundColor = XRHex(0xe0dfde);
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([kValidStr(self.alertTitle) length] != 0) {
            return 60;
        } else {
            return 0.01;
        }
    } else {
        return 5;
    }
    return 0.01;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self dismissWithCell:cell];
}

- (void)dismissWithCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1) {
        if (_dismissBlock) {
            
            [UIView animateWithDuration:0.22f animations:^{
                self.backgroundView.alpha = 0.0;
                self.tableView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if(finished) {
                    _dismissBlock(self, indexPath, cell.textLabel.text);
                    [self removeFromSuperview];
                }
            }];
            
            
        } else {
            [self dismiss];
        }
    } else {
        
        
        [UIView animateKeyframesWithDuration:0.22f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.backgroundView.alpha = 0.0;
            self.tableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            if(finished) {
                if (_clickBlock) {
                    _clickBlock(self, indexPath, cell.textLabel.text);
                }
                [self removeFromSuperview];
            }
            
        }];
    }
    
}

/**
 *  让UITablViewCel的分割线左对齐
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - private
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(![touch.view isEqual:self.tableView]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        [self dismissWithCell:cell];
    }
}

- (void)pop {
    self.backgroundView.alpha = 0.0;
    self.tableView.frame = CGRectMake(0, kScreenHeight(), kScreenWidth(), [self heightForTableView]);
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    [UIView animateKeyframesWithDuration:0.22 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.backgroundView.alpha = 1.0;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -[self heightForTableView]);
    } completion:^(BOOL finished) {
        
    }];
}

- (CGFloat)heightForTableView {
    CGFloat rowHeight = kScreenWidth() > 320 ? 55 : 50;
    return  rowHeight * (self.subTitlesArray.count + 1) + 5.0f + ([kValidStr(self.alertTitle) length] != 0 ? 60 : 0);
}

- (void)dismiss {
    [UIView animateWithDuration:0.22f animations:^{
        self.backgroundView.alpha = 0.0;
        self.tableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if(!_tableView) {
        UITableView *tab = [[UITableView alloc] init];
        tab.delegate = self;
        tab.dataSource = self;
        tab.tableFooterView = nil;
        [tab setSeparatorInset:UIEdgeInsetsZero];
        [tab setLayoutMargins:UIEdgeInsetsZero];
        [self addSubview:tab];
        tab.scrollEnabled = NO;
        _tableView = tab;
    }
    return _tableView;
}

- (UIView *)backgroundView {
    if(!_backgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
        [self addSubview:view];
        _backgroundView = view;
    }
    return _backgroundView;
}

- (NSMutableArray *)subTitlesArray {
    if(!_subTitlesArray) {
        _subTitlesArray = [[NSMutableArray alloc] init];
    }
    return _subTitlesArray;
}

@end
