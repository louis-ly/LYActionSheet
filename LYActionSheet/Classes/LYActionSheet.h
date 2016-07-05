//
//  LYAlertView.h
//  LYWeiXin
//
//  Created by Joe on 16/7/4.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYActionSheet : UIView
/**
 *  Initialize the actionSheet with some buttonTitles.
 *
 *  @param otherButtonTitles The titles of any additional buttons you want to add. This parameter consists 
 *                           of a nil-terminated, comma-separated list of strings. For example, to specify 
 *                           two additional buttons, you could specify the value @"Button 1", @"Button 2", nil.
 *
 *  @return A newly initialized action sheet.
 */
- (instancetype)initWithButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  Initialize the actionSheet with an cancelButtonTitle, and some buttonTitles.
 *
 *  @param cancelButtonTitle The title of the cancel button. This button is added to the action sheet 
 *                           automatically and assigned an appropriate index, which is available from the 
 *                           cancelButtonIndex property. This button is displayed in black to indicate that
 *                           it represents the cancel action. Specify nil if you do not want a cancel button
 *                           or are presenting the action sheet on an iPad.
 *  @param otherButtonTitles The titles of any additional buttons you want to add. This parameter consists
 *                           of a nil-terminated, comma-separated list of strings. For example, to specify
 *                           two additional buttons, you could specify the value @"Button 1", @"Button 2", nil.
 *
 *  @return A newly initialized action sheet.
 */
- (instancetype)initWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  Initialize the actionSheet with an title, cancelButtonTitle, and some buttonTitles.
 *
 *  @param title             A string to display in the title area of the action sheet. Pass nil if you do 
 *                           not want to display any text in the title area.
 *  @param cancelButtonTitle The title of the cancel button. This button is added to the action sheet
 *                           automatically and assigned an appropriate index, which is available from the
 *                           cancelButtonIndex property. This button is displayed in black to indicate that
 *                           it represents the cancel action. Specify nil if you do not want a cancel button
 *                           or are presenting the action sheet on an iPad.
 *  @param otherButtonTitles The titles of any additional buttons you want to add. This parameter consists
 *                           of a nil-terminated, comma-separated list of strings. For example, to specify
 *                           two additional buttons, you could specify the value @"Button 1", @"Button 2", nil.
 *
 *  @return A newly initialized action sheet.
 */
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  Initialize the actionSheet with an title, cancelButtonTitle, destructiveButtonTitle, and some buttonTitles.
 *
 *  @param title             A string to display in the title area of the action sheet. Pass nil if you do
 *                           not want to display any text in the title area.
 *  @param cancelButtonTitle The title of the cancel button. This button is added to the action sheet
 *                           automatically and assigned an appropriate index, which is available from the
 *                           cancelButtonIndex property. This button is displayed in black to indicate that
 *                           it represents the cancel action. Specify nil if you do not want a cancel button
 *                           or are presenting the action sheet on an iPad.
 *  @param destructiveButtonTitle The title of the destructive button. This button is added to the action sheet
 *                                automatically and assigned an appropriate index, which is available from the
 *                                destructiveButtonIndex property. This button is displayed in red to indicate
 *                                that it represents a destructive behavior. Specify nil if you do not want a
 *                                destructive button.
 *  @param otherButtonTitles The titles of any additional buttons you want to add. This parameter consists
 *                           of a nil-terminated, comma-separated list of strings. For example, to specify
 *                           two additional buttons, you could specify the value @"Button 1", @"Button 2", nil.
 *
 *  @return A newly initialized action sheet.
 */
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  Displays an action sheet that originates from the application window.
 *
 *  @param clickedBlock a block called when the user presses on a specified button
 */
- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock;

/**
 *  Displays an action sheet that originates from the application window.
 *
 *  @param clickedBlock a block called when the user presses on a specified button
 *  @param cancelBlock  a block called when the user presses on cancel button in bottom
 */
- (void)showWithClickedButtonAtIndex:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))clickedBlock cancel:(void(^)(NSString *buttonTitle))cancelBlock;


/**
 *  hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
 *  it does not need to be called if the user presses on a button
 */
- (void)dismiss;
@end
