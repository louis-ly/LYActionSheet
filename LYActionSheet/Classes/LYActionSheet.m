//
//  LYAlertView.m
//  LYWeiXin
//
//  Created by Joe on 16/7/4.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYActionSheet.h"

#ifndef LY_iOS8
#define LY_iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#endif

#define LYActionSheetButtonHeight 50
#define LYActionSheetTitleViewHeight 65
#define LYActionSheetLineHeight 1
#define LYActionSheetCancelButtonGap 10 
#define LYActionSheetDismissTime 0.15
#define LYActionSheetShowTime 0.3
#define LYActionSheetBGAlpha 0.5
#define LYActionSheetButtonAlpha 0.8
#define LYActionSheetButtonHGAlpha 0.2

#define LYActionSheetTitleViewLabelColor [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]
#define LYActionSheetdestructiveButtonColor [UIColor colorWithRed:230/255.0 green:67/255.0 blue:64/255.0 alpha:1]
#define LYActionSheetBGColor [UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1]

#define LYActionSheetGetOtherButtonTitles va_list args; \
    va_start(args, otherButtonTitles); \
    NSMutableArray *array = [NSMutableArray array]; \
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args, NSString*)) \
        [array addObject:str]; \
    va_end(args); \

typedef NS_OPTIONS(NSUInteger, LYLayoutAttribute) {
    LyTop = 1,
    LyBottom,
    LyLeft,
    LyRight,
    LyWidth,
    LyHeight
};

@interface LYActionSheetButton : UIButton

@end
@implementation LYActionSheetButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:LYActionSheetButtonAlpha];
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchCancel];
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (void)touchDown {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:LYActionSheetButtonHGAlpha];
}

- (void)touchCancel {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:LYActionSheetButtonAlpha];
}

@end

@interface LYActionSheet ()
@property (nonatomic, copy) void(^clickedBlock)(NSInteger buttonIndex, NSString *buttonTitle);
@property (nonatomic, copy) void(^cancelBlock)(NSString *buttonTitle);
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSLayoutConstraint *sheetViewBottomConstraint;
@end

@implementation LYActionSheet

- (instancetype)initWithButtonTitles:(NSString *)otherButtonTitles, ... {
    LYActionSheetGetOtherButtonTitles
    return [self initWithTitle:nil cancelButtonTitle:nil destructiveExist:NO buttonTitles:array];
}

- (instancetype)initWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    LYActionSheetGetOtherButtonTitles
    return [self initWithTitle:nil cancelButtonTitle:cancelButtonTitle destructiveExist:NO buttonTitles:array];
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    LYActionSheetGetOtherButtonTitles
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveExist:NO buttonTitles:array];
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    LYActionSheetGetOtherButtonTitles
    BOOL destructiveExist = NO;
    if (destructiveButtonTitle && ![destructiveButtonTitle isEqualToString:@""]) {
        [array insertObject:destructiveButtonTitle atIndex:0];
        destructiveExist = YES;
    }
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveExist:destructiveExist buttonTitles:array];
}

- (NSLayoutConstraint *)item:(UIView *)view1 attr:(LYLayoutAttribute)attr1 toItem:(UIView *)view2 attr:(LYLayoutAttribute)attr2 cons:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:[self transformFromLyAttr:attr1] relatedBy:NSLayoutRelationEqual toItem:view2 attribute:[self transformFromLyAttr:attr2] multiplier:1 constant:constant];
}
- (NSLayoutAttribute)transformFromLyAttr:(LYLayoutAttribute)attr {
    if (attr == LyTop) return NSLayoutAttributeTop;
    if (attr == LyBottom) return NSLayoutAttributeBottom;
    if (attr == LyLeft) return NSLayoutAttributeLeft;
    if (attr == LyRight) return NSLayoutAttributeRight;
    if (attr == LyWidth) return NSLayoutAttributeWidth;
    if (attr == LyHeight) return NSLayoutAttributeHeight; return NSLayoutAttributeNotAnAttribute;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveExist:(BOOL)destructiveExist buttonTitles:(NSArray *)array {
    self = [super init];
    if (!self) return nil;
    self.frame = [[UIApplication sharedApplication].delegate window].bounds;
    
    // create black bottom view
    _blackView = [UIView new];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0;
    _blackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self addSubview:_blackView];
    [self addConstraints:@[[self item:_blackView attr:LyTop toItem:self attr:LyTop cons:0],
                           [self item:_blackView attr:LyBottom toItem:self attr:LyBottom cons:0],
                           [self item:_blackView attr:LyLeft toItem:self attr:LyLeft cons:0],
                           [self item:_blackView attr:LyRight toItem:self attr:LyRight cons:0]]];

    // create sheet view
    _sheetView = [[UIView alloc] init];
    _sheetView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_sheetView];
    _sheetViewBottomConstraint = [self item:_sheetView attr:LyTop toItem:self attr:LyBottom cons:0];
    [self addConstraints:@[[self item:_sheetView attr:LyLeft toItem:self attr:LyLeft cons:0],
                           [self item:_sheetView attr:LyRight toItem:self attr:LyRight cons:0],
                           _sheetViewBottomConstraint]];
    
    // create extralight blurView when the system version is more than iOS8
    UIVisualEffectView *bgBlurView = nil;
    if (LY_iOS8) {
        bgBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        [_sheetView addSubview:bgBlurView];
        bgBlurView.translatesAutoresizingMaskIntoConstraints = NO;
        [_sheetView addConstraints:@[[self item:bgBlurView attr:LyTop toItem:_sheetView attr:LyTop cons:0],
                                     [self item:bgBlurView attr:LyBottom toItem:_sheetView attr:LyBottom cons:0],
                                     [self item:bgBlurView attr:LyLeft toItem:_sheetView attr:LyLeft cons:0],
                                     [self item:bgBlurView attr:LyRight toItem:_sheetView attr:LyRight cons:0]]];
    } else {
        _sheetView.backgroundColor = LYActionSheetBGColor;
    }
    
    // create titleView
    UIView *titleView = nil;
    if (title && ![title isEqualToString:@""]) {
        titleView = [UIView new];
        titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:LYActionSheetButtonAlpha];
        [_sheetView addSubview:titleView];
        _titleView = titleView;
        _titleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[[self item:titleView attr:LyLeft toItem:_sheetView attr:LyLeft cons:0],
                               [self item:titleView attr:LyRight toItem:_sheetView attr:LyRight cons:0],
                               [self item:titleView attr:LyTop toItem:_sheetView attr:LyTop cons:0],
                               [self item:titleView attr:LyHeight toItem:nil attr:0 cons:LYActionSheetTitleViewHeight]]];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = LYActionSheetTitleViewLabelColor;
        [titleView addSubview:titleLabel];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [titleView addConstraints:@[[self item:titleLabel attr:LyTop toItem:titleView attr:LyTop cons:0],
                                     [self item:titleLabel attr:LyBottom toItem:titleView attr:LyBottom cons:0],
                                     [self item:titleLabel attr:LyLeft toItem:titleView attr:LyLeft cons:0],
                                     [self item:titleLabel attr:LyRight toItem:titleView attr:LyRight cons:0]]];
    }

    // create other action button
    UIView *aboveView = _titleView ? _titleView : _sheetView;
    for (int i = 0; i < array.count; i++) {
        LYActionSheetButton *btn = [LYActionSheetButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sheetView addSubview:btn];
        
        // set destrctive button titleColor to red
        if (i == 0 && destructiveExist) {
            [btn setTitleColor:LYActionSheetdestructiveButtonColor forState:UIControlStateNormal];
        }

        btn.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat topMargin = (!_titleView && i == 0) ? 0 : LYActionSheetLineHeight;
        LYLayoutAttribute attr = aboveView == _sheetView ? LyTop : LyBottom;
        [_sheetView addConstraints:@[[self item:btn attr:LyTop toItem:aboveView attr:attr cons:topMargin],
                                     [self item:btn attr:LyLeft toItem:_sheetView attr:LyLeft cons:0],
                                     [self item:btn attr:LyRight toItem:_sheetView attr:LyRight cons:0],
                                     [self item:btn attr:LyHeight toItem:nil attr:0 cons:LYActionSheetButtonHeight]]];
        aboveView = btn;
    }

    // create cancel action button
    LYActionSheetButton *cancelBtn = [LYActionSheetButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [cancelBtn setTitle:(cancelButtonTitle && ![cancelButtonTitle isEqualToString:@""]) ? cancelButtonTitle : @"取消"  forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:cancelBtn];
    [_sheetView addConstraints:@[[self item:cancelBtn attr:LyLeft toItem:_sheetView attr:LyLeft cons:0],
                                 [self item:cancelBtn attr:LyRight toItem:_sheetView attr:LyRight cons:0],
                                 [self item:cancelBtn attr:LyTop toItem:aboveView attr:LyBottom cons:LYActionSheetCancelButtonGap],
                                 [self item:cancelBtn attr:LyHeight toItem:nil attr:0 cons:LYActionSheetButtonHeight],
                                 [self item:cancelBtn attr:LyBottom toItem:_sheetView attr:LyBottom cons:0]]];
    return self;
}

- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock {
    [self showWithClickedButtonAtIndex:clickedBlock cancel:nil];
}

- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock cancel:(void(^)(NSString *buttonTitle))cancelBlock {
    _clickedBlock = clickedBlock;
    _cancelBlock = cancelBlock;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.frame = window.bounds;
    [window addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _sheetViewBottomConstraint.constant = -_sheetView.frame.size.height;
        [UIView animateWithDuration:LYActionSheetShowTime animations:^{
            _blackView.alpha = LYActionSheetBGAlpha;
            [_sheetView.superview layoutIfNeeded];
        } completion:nil];
    });
}


- (void)selectBtnDidClicked:(UIButton *)btn {
    [self dismiss];
    if (_clickedBlock) _clickedBlock(btn.tag, btn.currentTitle);
}

- (void)cancelBtnDidClicked:(UIButton *)btn {
    [self dismiss];
    if (_cancelBlock) _cancelBlock(btn.currentTitle);
}

- (void)dismiss {
    _sheetViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:LYActionSheetDismissTime animations:^{
        _blackView.alpha = 0;
        [_sheetView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = [[UIApplication sharedApplication].delegate window].bounds;
}
@end
