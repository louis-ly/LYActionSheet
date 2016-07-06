//
//  ViewController.m
//  LYActionSheetDemo
//
//  Created by Louis on 16/7/4.
//  Copyright © 2016年 Louis. All rights reserved.
//

#import "ViewController.h"
#import "LYActionSheet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;
@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinkBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _blueBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _yellowBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _pinkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)uploadAvatar:(UIButton *)sender {
    LYActionSheet *actionSheet = [[LYActionSheet alloc] initWithButtonTitles:@"拍照", @"从手机相册选择", @"保存图片", nil];
    [actionSheet showWithClickedButtonAtIndex:^(NSInteger buttonIndex, NSString *buttonTitle) {
        NSLog(@"buttonIndex: %ld", buttonIndex);
        _label.text = [NSString stringWithFormat:@"您选择了: %@", buttonTitle];
    }];
}

- (IBAction)chooseOne:(UIButton *)sender {
    LYActionSheet *actionSheet = [[LYActionSheet alloc] initWithTitle:@"老妈和老婆同时掉进水里, 先救谁?" cancelButtonTitle:@"都不救" otherButtonTitles:@"救老妈", @"救老婆", nil];
    [actionSheet showWithClickedButtonAtIndex:^(NSInteger buttonIndex, NSString *buttonTitle) {
        NSLog(@"buttonIndex: %ld", buttonIndex);
        _label.text = [NSString stringWithFormat:@"您选择了: %@", buttonTitle];
    } cancel:^(NSString *buttonTitle) {
        NSLog(@"cancel button did clicked");
        _label.text = [NSString stringWithFormat:@"您选择了: %@", buttonTitle];
    }];
}

- (IBAction)confirmToDelete:(UIButton *)sender {
    LYActionSheet *actionSheet = [[LYActionSheet alloc] initWithTitle:@"是否删除该条消息?" cancelButtonTitle:nil destructiveButtonTitle:@"删除" otherButtonTitles:nil];
    [actionSheet showWithClickedButtonAtIndex:^(NSInteger buttonIndex, NSString *buttonTitle) {
        NSLog(@"buttonIndex: %ld", buttonIndex);
        _label.text = [NSString stringWithFormat:@"您选择了: %@", buttonTitle];
    } cancel:^(NSString *buttonTitle) {
        NSLog(@"cancel button did clicked");
        _label.text = [NSString stringWithFormat:@"您选择了: %@", buttonTitle];
    }];
}
@end
