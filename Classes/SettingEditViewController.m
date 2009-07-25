/*

File: EditingViewController.m
Abstract: 
 View controller for editing the content of a specific item.

*/

#import "SettingEditViewController.h"
#import "SettingEditCell.h"

#import "VideoStreamingAppDelegate.h"
#import "RootViewController.h"
#import "SettingViewController.h"

@interface SettingEditViewController(Private)
-(void) myKeyboardWillShow:(NSNotification*)aNotification;
@end

@implementation SettingEditViewController

@synthesize editingItem, editingItemCopy, editingContent, sectionName, tableView, headerView;

// When we set the editing item, we also make a copy in case edits are made and then canceled - then we can
// restore from the copy.
- (void)setEditingItem:(NSMutableDictionary *)anItem {
    [editingItem release];
    editingItem = [anItem retain];
    self.editingItemCopy = editingItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [editingItem release];
    [editingItemCopy release];
	[nameField release];
    [editingContent release];
    [sectionName release];
	tableView.delegate =nil;
	tableView.dataSource = nil;
    [tableView release];
    [headerView release];
    [super dealloc];
}

- (IBAction)cancel:(id)sender {
    // cancel edits, restore all values from the copy
    newItem = NO;
    [editingItem setValuesForKeysWithDictionary:editingItemCopy];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // save edits to the editing item and add new item to the content.
	if([nameCell.textField.text length] == 0) return;
	
    [editingItem setValue:nameCell.textField.text forKey:@"Name"];
    if (newItem) {
        [editingContent addObject:editingItem];
        newItem = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    // use an empty view to position the cells in the vertical center of the portion of the view not covered by 
    // the keyboard
    self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 100)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = [NSString stringWithFormat:@"Editing %@", sectionName];
    // If the editing item is nil, that indicates a new item should be created
    if (editingItem == nil) {
        self.editingItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"Name", nil];
		// rather than immediately add the new item to the content array, set a flag. When the user saves, add the 
        // item then; if the user cancels, no action is needed.
        newItem = YES;
    }
    [tableView reloadData];
    if (!nameCell) {
        nameCell = [[SettingEditCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"NameCell"];
    }
    nameCell.textField.placeholder = sectionName;
    nameCell.textField.text = [editingItem valueForKey:@"Name"];
	nameCell.textField.keyboardType = UIKeyboardTypeURL;
    // Starts editing in the name field and shows the keyboard
    [nameCell.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    // hides the keyboard
    [nameCell.textField resignFirstResponder];
}

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(indexPath.section);
    if (indexPath.section == 1) {
        [editingItem setValue:nameCell.textField.text forKey:@"Name"];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Have an accessory view for the second section only
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
}

// Make the header height in the first section 45 pixels
- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 45.0 : 10.0;
}

// Show a header for only the first section
- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
    return (section == 0) ? headerView : nil;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return (indexPath.section == 0) ? nameCell : typeCell;
	return nameCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
