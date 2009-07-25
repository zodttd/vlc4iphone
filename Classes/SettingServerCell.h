/*

File: SettingServerCell.h
Abstract: 
 Custom table cell used in the main view's table. Capable of displaying in two
modes - a "type:name" mode for existing
 data and a "prompt" mode when used as a placeholder for data creation.

*/

#import <UIKit/UIKit.h>

@interface SettingServerCell : UITableViewCell {
    UITextField *name;
    UITextField *prompt;
    BOOL promptMode;
}

@property (readonly, retain) UITextField *name;
@property (readonly, retain) UITextField *prompt;
@property BOOL promptMode;

@end
