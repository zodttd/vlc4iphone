/*

File: DetailViewController.m
Abstract: 
 Main view controller for the app. Displays a grouped table view and manages
edits to the table, including
 add, delete, reorder, and navigation to edit the contents of individual items.

*/

#import "SettingViewController.h"
#import "SettingServerCell.h"
#import "SettingPlayerCell.h"
#import "SettingEditViewController.h"
#import "SettingPlayerController.h"
#import "VideoStreamingAppDelegate.h"
#import "Constants.h"

@implementation SettingViewController

@synthesize data, tableView, editViewController, pathToUserCopyOfPlist;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle 
{ 
    self = [super initWithNibName:nibName bundle:nibBundle]; 
    if (self) { 
        self.title = @"Settings"; 
		//        self.tabBarItem.image = [UIImage imageNamed:@"Green.png"]; 
		self.navigationItem.title = @"Settings";
		//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editingViewController)] autorelease];
		
		[self loadAppSettings];
		[self create_UIControls];
    } 
    return self; 
} 

- (void)dealloc {
	[super dealloc];
	tableView.delegate = nil;
	tableView.dataSource = nil;
    [tableView dealloc];
    [data dealloc];
    [editViewController dealloc];
	[pathToUserCopyOfPlist dealloc];
	[switchCtl1 dealloc];
	[switchCtl2 dealloc];
	[switchCtl3 dealloc];
	[segmentedControl dealloc];
}

- (void)viewDidLoad {
	// Add the built-in edit button item to the navigation bar. This item automatically toggles between
	// "Edit" and "Done" and updates the view controller's state accordingly.
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[tableView reloadData];
//	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self writeToUserPlist];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - BarButtonItem Functions

- (SettingEditViewController *)editingViewController {
    // Instantiate the editing view controller if necessary.
    if (editViewController == nil) {
        SettingEditViewController *controller = [[SettingEditViewController alloc] initWithNibName:@"SettingEditView" bundle:nil];
        self.editViewController = controller;
        [controller release];
    }
    return editViewController;
}

#pragma mark Table Content and Appearance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // The number of sections is based on the number of items in the data property list.
  return 1; //[data count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // The number of rows in each section depends on the number of sub-items in each item in the data property list. 
    NSInteger count = [[[data objectAtIndex:section] valueForKeyPath:@"content.@count"] intValue];
    // If we're in editing mode, we add a placeholder row for creating new items.
    if (section ==kServerSection && self.editing) count++;
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	UITableViewCell* tableCell; //dummy
	switch (indexPath.section)
	{
		case kPlayerSection:{
			SettingPlayerCell *cell = (SettingPlayerCell *)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
			if (cell == nil) {
				cell = [[[SettingPlayerCell alloc] initWithFrame:CGRectZero	reuseIdentifier:@"PlayerCell"] autorelease];
			}

			NSDictionary *section = [data objectAtIndex:kPlayerSection];
			
			if (section) {
				
				NSDictionary *content = [section valueForKey:@"content"];
				NSDictionary *item;
				
				NSArray *values = [NSArray arrayWithObjects:
								   /*@"opt_ffmpegskipframe",*/@"opt_noaudio",
								   /*@"opt_nodroplateframes", @"opt_ffmpeglowres",*/ nil];
				NSArray *controls = [NSArray arrayWithObjects:
									/* switchCtl1,*/switchCtl2,/*switchCtl3,segmentedControl,*/nil];
									
				if (content) {
						item = [content valueForKey:[values objectAtIndex:row]];
						((SettingPlayerCell *) cell).view = [controls objectAtIndex:row];
					// set default value according to class
					if ([[controls objectAtIndex:row] isKindOfClass:[UISwitch class]])
						[[controls objectAtIndex:row] setOn:[[item valueForKey:@"value"]integerValue]	animated:YES];
					else if ([[controls objectAtIndex:row] isKindOfClass:[UISegmentedControl class]])
						[[controls objectAtIndex:row] setSelectedSegmentIndex:[[item valueForKey:@"value"]integerValue]];
				}
			
			((SettingPlayerCell *) cell).nameLabel.text = [item valueForKey:@"name"] ;
			}
			return cell;
		}
	
		case kServerSection: {
			
			SettingServerCell *cell = (SettingServerCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
			if (cell == nil) {
				cell = [[[SettingServerCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DetailCell"] autorelease];
				cell.hidesAccessoryWhenEditing = NO;
			}
			
			// The DetailCell has two modes of display - either a type/name pair or a prompt for creating a new item of a type
			// The type derives from the section, the name from the item.
			NSDictionary *section = [data objectAtIndex:kServerSection];
			
			if (section) {
				NSArray *content = [section valueForKey:@"content"];
				if (content && row < [content count]) {
					NSDictionary *item = (NSDictionary *)[content objectAtIndex:row];
					cell.name.text = [item valueForKey:@"Name"];
					cell.promptMode = NO;
				} else {
					cell.prompt.text = [NSString stringWithFormat:@"Add new %@", [section valueForKey:@"name"]];
					cell.promptMode = YES;
				}
			} else {
				//        cell.type.text = @"";
				cell.name.text = @"";
			}
			return cell;
		}
	}    
	return tableCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == kServerSection)? YES: NO;
}

// The accessory view is on the right side of each cell. We'll use a "disclosure" indicator in editing mode,
// to indicate to the user that selecting the row will navigate to a new view where details can be edited.
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return (self.editing && indexPath.section==kServerSection) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.
    NSDictionary *section = [data objectAtIndex:indexPath.section];
    if (section && indexPath.section == kServerSection) {
        NSArray *content = [section valueForKey:@"content"];
        if (content) {
            if (indexPath.row >= [content count]) {
                return UITableViewCellEditingStyleInsert;
            } else {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark Table Selection 

// Called after selection. In editing mode, this will navigate to a new view controller.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing && indexPath.section == kServerSection) {
        // Don't maintain the selection. We will navigate to a new view so there's no reason to keep the selection here.
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // Go to edit view
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the editing view controller.
            SettingEditViewController *controller = self.editingViewController;
            // Pass the item being edited to the editing controller.
            NSMutableArray *content = [section valueForKey:@"content"];
            if (content && indexPath.row < [content count]) {
                // The row selected is one with existing content, so that content will be edited.
                NSMutableDictionary *item = (NSMutableDictionary *)[content objectAtIndex:indexPath.row];
                controller.editingItem = item;
            } else {
                // The row selected is a placeholder for adding content. The editor should create a new item.
                controller.editingItem = nil;
                controller.editingContent = content;
            }
            // Additional information for the editing controller.
            controller.sectionName = [section valueForKey:@"name"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark Editing

// Set the editing state of the view controller. We pass this down to the table view and also modify the content
// of the table to insert a placeholder row for adding content when in editing mode.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
    // Calculate the index paths for all of the placeholder rows based on the number of items in each section.
    NSArray *indexPaths = [NSArray arrayWithObjects:
						   //[NSIndexPath indexPathForRow:[[[data objectAtIndex:0] valueForKeyPath:@"content.@count"] intValue] inSection:0], nil];
						   [NSIndexPath indexPathForRow:[[[data objectAtIndex:1] valueForKeyPath:@"content.@count"] intValue] inSection:1], nil];
//            [NSIndexPath indexPathForRow:[[[data objectAtIndex:2] valueForKeyPath:@"content.@count"] intValue] inSection:2], nil];

	[tableView beginUpdates];
	[tableView setEditing:editing animated:YES];
    if (editing) {
        // Show the placeholder rows
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        // Hide the placeholder rows.
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    [tableView endUpdates];
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
            forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == kPlayerSection) return;
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            NSMutableArray *content = [section valueForKey:@"content"];
            if (content && indexPath.row < [content count]) {
                [content removeObjectAtIndex:indexPath.row];
            }
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the editing view controller.
            SettingEditViewController *controller = self.editingViewController;
            NSMutableArray *content = [section valueForKey:@"content"];
            // A "nil" editingItem indicates the editor should create a new item.
            controller.editingItem = nil;
            // The group to which the new item should be added.
            controller.editingContent = content;
            controller.sectionName = [section valueForKey:@"name"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark Row reordering

// Determine whether a given row is eligible for reordering or not. In this app, all rows except the placeholders for
// new content are eligible, so the test is just the index path row against the number of items in the content.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // get the size of the content array
    NSUInteger numberOfRowsInSection = [[[data objectAtIndex:indexPath.section] valueForKeyPath:@"content.@count"] intValue];
    // Don't allow the placeholder to be moved.
    return ((indexPath.section == kServerSection) && (indexPath.row < numberOfRowsInSection));
}

// This allows the delegate to retarget the move destination to an index path of its choice. In this app, we don't want
// the user to be able to move items from one group to another, or to the last row of its group (the last row is
// reserved for the add-item placeholder).
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
        toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	
	if (sourceIndexPath.section == kPlayerSection) return sourceIndexPath;
	
    NSDictionary *section = [data objectAtIndex:sourceIndexPath.section];
    NSUInteger sectionCount = [[section valueForKey:@"content"] count];
    // Check to see if the source and destination sections match. If not, retarget to either the top of the source
    // section (if the destination is above the source) or the bottom of the source section if not.
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSUInteger rowInSourceSection = (sourceIndexPath.section > proposedDestinationIndexPath.section) ? 0 : 
                sectionCount - 1;
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
    // Check for moving to the placeholder row. If so, retarget to just above that row.
    } else if (proposedDestinationIndexPath.row >= sectionCount) {
        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
    }
    // Allow the proposed destination.
    return proposedDestinationIndexPath;
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
            toIndexPath:(NSIndexPath *)toIndexPath {
	
	if (toIndexPath.section == kPlayerSection) return;
	
    NSDictionary *section = [data objectAtIndex:fromIndexPath.section];
    if (section && fromIndexPath.section == toIndexPath.section) {
        NSMutableArray *content = [section valueForKey:@"content"];
        if (content && toIndexPath.row < [content count]) {
            id item = [[content objectAtIndex:fromIndexPath.row] retain];
            [content removeObject:item];
            [content insertObject:item atIndex:toIndexPath.row];
            [item release];
        }
    }
}

#pragma mark Public methods
-(void)loadAppSettings{
	// Check for data in Documents directory. Copy default appData.plist to Documents if not found.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory = [appDelegate getDocumentsDirectory];
	
    self.pathToUserCopyOfPlist = [documentsDirectory stringByAppendingPathComponent:@"appData.plist"];
    if ([fileManager fileExistsAtPath:pathToUserCopyOfPlist] == NO) {
        NSString *pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:@"appData" ofType:@"plist"];
        if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:pathToUserCopyOfPlist error:&error] == NO) {
            NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
        }
    }
    // Unarchive the data, store it in the local property, and pass it to the main view controller
    self.data = [[[NSMutableArray alloc] initWithContentsOfFile:pathToUserCopyOfPlist] autorelease];
	[self.tableView reloadData];
}	

- (NSUInteger)countOfServers {
	return [[[data objectAtIndex:kServerSection] valueForKeyPath:@"content.@count"] intValue];
}

-(NSString*)getSetting:(NSString*) settingName
{
	return [[self getDictionaryItem:settingName] objectForKey:@"value"];	
}

#pragma mark Private Methods
-(void) writeToUserPlist
{
	[data writeToFile:pathToUserCopyOfPlist atomically:NO];
}

@end
