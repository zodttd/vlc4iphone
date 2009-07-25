/*

File: SettingEditCell.h
Abstract: 
 Custom table cell used in the editing view's table. Contains a UITextField for
in-place editing of content.

*/

#import <UIKit/UIKit.h>

@interface SettingEditCell : UITableViewCell {
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
