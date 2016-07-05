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

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveExist:(BOOL)destructiveExist buttonTitles:(NSArray *)array {
    self = [super init];
    if (!self) return nil;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat actionSheetHeight = 0;
    CGFloat actionBtnHeight = LYActionSheetButtonHeight;
    
    // create black bottom view
    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0;
    [_blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self addSubview:_blackView];

    // create sheet view
    _sheetView = [[UIView alloc] init];
    [self addSubview:_sheetView];
    
    // create extralight blurView when the system version is more than iOS8
    UIVisualEffectView *bgBlurView = nil;
    if (LY_iOS8) {
        bgBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        [_sheetView addSubview:bgBlurView];
    } else {
        _sheetView.backgroundColor = LYActionSheetBGColor;
    }
    
    // create titleView
    UIView *titleView = nil;
    if (title && ![title isEqualToString:@""]) {
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, LYActionSheetTitleViewHeight)];
        titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:LYActionSheetButtonAlpha];
        [_sheetView addSubview:titleView];
        _titleView = titleView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleView.bounds];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = LYActionSheetTitleViewLabelColor;
        [titleView addSubview:titleLabel];
        
        actionSheetHeight = CGRectGetMaxY(titleView.frame) + LYActionSheetLineHeight;
    }

    // create other action button
    for (int i = 0; i < array.count; i++) {
        LYActionSheetButton *btn = [LYActionSheetButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        btn.tag = i;
        btn.frame = CGRectMake(0, actionSheetHeight, screenWidth, actionBtnHeight);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sheetView addSubview:btn];
        
        // set destrctive button titleColor to red
        if (i == 0 && destructiveExist) {
            [btn setTitleColor:LYActionSheetdestructiveButtonColor forState:UIControlStateNormal];
        }
        
        actionSheetHeight += actionBtnHeight + LYActionSheetLineHeight;
    }
    
    actionSheetHeight += LYActionSheetCancelButtonGap;
    
    // create cancel action button
    LYActionSheetButton *cancelBtn = [LYActionSheetButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, actionSheetHeight, screenWidth, actionBtnHeight);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [cancelBtn setTitle:(cancelButtonTitle && ![cancelButtonTitle isEqualToString:@""]) ? cancelButtonTitle : @"取消"  forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:cancelBtn];
    
    actionSheetHeight += actionBtnHeight;
    
    _sheetView.frame = CGRectMake(0, screenHeight, screenWidth, actionSheetHeight);
    bgBlurView.frame = _sheetView.bounds;
    return self;
}

- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock {
    [self showWithClickedButtonAtIndex:clickedBlock cancel:nil];
}

- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock cancel:(void(^)(NSString *buttonTitle))cancelBlock {
    _clickedBlock = clickedBlock;
    _cancelBlock = cancelBlock;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    [UIView animateWithDuration:LYActionSheetShowTime animations:^{
        _blackView.alpha = LYActionSheetBGAlpha;
        _sheetView.transform = CGAffineTransformMakeTranslation(0, -_sheetView.frame.size.height);
    } completion:nil];
}


- (void)selectBtnDidClicked:(UIButton *)btn {
    if (_clickedBlock) _clickedBlock(btn.tag, btn.currentTitle);
    [self dismiss];
}

- (void)cancelBtnDidClicked:(UIButton *)btn {
    if (_cancelBlock) _cancelBlock(btn.currentTitle);
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:LYActionSheetDismissTime animations:^{
        _blackView.alpha = 0;
        _sheetView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
