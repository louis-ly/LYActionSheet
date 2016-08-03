# LYAcitionSheet （高仿微信ActionSheet）
一个高仿微信ActionSheet的弹框. 

![image](http://oad5jrdyg.bkt.clouddn.com/LYActionSheet_Snapshot1.gif)

AutoLayout屏幕旋转适配

![image](http://oad5jrdyg.bkt.clouddn.com/LYActionSheet_Snapshot2.gif)

## Podfile
[CocoaPods](http://cocoapods.org/) is the recommended method to install MessageDisplayKit, just add the following line to `Podfile` 

支持[CocoaPods](http://cocoapods.org/). 只要在`Podfile`文件中加入一行

```
pod 'LYActionSheet'
```

and run `pod install`, then you're all done!

接着在终端输入`pod install`即可


## How to use

Easy to drop into your project.

该库很容易接入项目

1、import LYActionSheet header file.

1.导入头文件LYActionSheet.h

```
#import "LYActionSheet.h" 
```

2、Initialize LYActionSheet class. There have four methods to initialize.

2.本库提供了有四个初始化的方法

```
- (instancetype)initWithButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
```

```
- (instancetype)initWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
```

```
- (instancetype)initWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
```

```
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
```

3、Show the actionSheet, block will be called when the user presses on button.

3.调用显示弹框. 用户点击选项按钮是block会调用.

```
- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock;
```

```
- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock cancel:(void(^)(NSString *buttonTitle))cancelBlock;
```