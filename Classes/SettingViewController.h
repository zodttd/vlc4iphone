/*

File: DetailViewController.h
Abstract: 
 Main view controller for the app. Displays a grouped table view and manages
edits to the table, including
 add, delete, reorder, and navigation to edit the contents of individual items.

*/

#import <UIKit/UIKit.h>

// Forward declaration of the editing view controller's class for the compiler.
@class SettingEditViewController;

@interface SettingViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
    NSMutableArray *data;
    SettingEditViewController *editViewController;
	NSString *pathToUserCopyOfPlist;
	
	UISwitch	*switchCtl1;
	UISwitch	*switchCtl2;
	UISwitch	*switchCtl3;
	UISegmentedControl *segmentedControl;
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) SettingEditViewController *editViewController;
@property (nonatomic, copy) NSString *pathToUserCopyOfPlist;
//@property (nonatomic, retain) UISegmentedControl *segmentedControl;

-(void) loadAppSettings;
-(NSUInteger) countOfServers;
-(NSString*)getSetting:(NSString*) settingName;
-(void) writeToUserPlist;

@end
