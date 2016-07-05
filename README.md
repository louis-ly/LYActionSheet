# LYAcitionSheet （高仿微信ActionSheet）
一个高仿微信ActionSheet的弹框

![image](https://github.com/Joe-Liuyi/LYActionSheet/blob/master/gif.gif)


## Podfile
[CocoaPods](http://cocoapods.org/) is the recommended method to install MessageDisplayKit, just add the following line to `Podfile`  

```
pod 'MessageDisplayKit'
```
and run `pod install`, then you're all done!


## How to use

Easy to drop into your project.   

1、#import "LYActionSheet.h"  

2、Initialize LYActionSheet class. There have four methods to initialize.

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

```
- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock;
```

```
- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock cancel:(void(^)(NSString *buttonTitle))cancelBlock;
```