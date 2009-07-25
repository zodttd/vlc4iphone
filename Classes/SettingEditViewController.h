/*

File: EditingViewController.h
Abstract: 
 View controller for editing the content of a specific item.

*/

#import <UIKit/UIKit.h>

@class SettingEditCell;

@interface SettingEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *editingItem;
    NSDictionary *editingItemCopy;
    UITextField *nameField;
//    UITextField *typeField;
    UITableView *tableView;
    SettingEditCell *nameCell;
    BOOL newItem;
    NSMutableArray *editingContent;
    NSString *sectionName;
    UIView *headerView;
}

@property (nonatomic, retain) NSMutableDictionary *editingItem;
@property (nonatomic, copy) NSDictionary *editingItemCopy;
@property (nonatomic, retain) NSMutableArray *editingContent;
@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIView *headerView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
    
@end
