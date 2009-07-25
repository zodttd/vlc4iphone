//
//  LocalViewController.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月6日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import "LocalViewController.h"
#import "VideoStreamingAppDelegate.h"

@interface LocalViewController(private)

-(NSString*) fileTypeOfFile:(NSString*) file;
-(UIImage*) imageForFileType:(NSString*) fileType;
- (UITableViewCell *)fileCellWithReuseIdentifier:(NSString *)identifier;

@end

@implementation LocalViewController

@synthesize tableView;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle 
{ 
    self = [super initWithNibName:nibName bundle:nibBundle]; 
    if (self) { 
        self.title = @"vlc4iphone"; 
		self.navigationItem.prompt = @"vlc4iphone";
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Up A Dir" style:UIBarButtonItemStyleBordered target:self action:@selector(backClicked:)] autorelease];

		currentFolderItems = [[NSMutableArray alloc] init];
		
		currentPath = [[NSString alloc] initWithString:@"/var/mobile"];
    }
    return self; 
} 


- (void)viewDidLoad {
    [super viewDidLoad];

	[self refreshCurrentFolder:currentPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[currentPath release];
	[currentFolderItems release];
    [super dealloc];
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [currentFolderItems count];
}

#define IMAGE_TAG 1
#define NAME_TAG 2

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString* fileName = [[currentFolderItems objectAtIndex:indexPath.row] objectForKey:@"fileName"];
	NSString* fileType = [[currentFolderItems objectAtIndex:indexPath.row] objectForKey:@"fileType"];
	
	BOOL isDir = [fileType isEqualToString:@"directory"];
	
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [self fileCellWithReuseIdentifier:CellIdentifier];
	}
	
	UILabel* nameLable = (UILabel*)[cell viewWithTag:NAME_TAG];
	UIImageView* iconImage = (UIImageView*)[cell viewWithTag:IMAGE_TAG];
	
	nameLable.text = fileName;
	iconImage.image = [self imageForFileType:fileType];
	
	if(isDir)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

    return cell;
}


- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
	NSString* fileType = [[currentFolderItems objectAtIndex:indexPath.row] objectForKey:@"fileType"];
	BOOL isDir = ([fileType isEqualToString:@"directory"]);
	NSString* filePath = [currentPath stringByAppendingPathComponent:[[currentFolderItems objectAtIndex:indexPath.row] objectForKey:@"fileName"]];
	
	if(isDir)
	{
		[self refreshCurrentFolder:filePath];
	}
	else {
		if([fileType isEqualToString:@"QuickTime Video"])
			[appDelegate playVideoInDefaultPlayerWithPath:filePath usingURL:0];
		else if([fileType isEqualToString:@"VLC Video"])
			[appDelegate playVideoInVLCPlayerWithPath:filePath];
    else
      [appDelegate playVideoInVLCPlayerWithPath:filePath];
	}

	[myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//	/*
//	 Return the index titles for each of the sections (e.g. "A", "B", "C"...).
//	 Use key-value coding to get the value for the key @"letter" in each of the dictionaries in list.
//	 */
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//}
// 

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark private methods
- (void)refreshCurrentFolder:(NSString*)path 
{	
	[currentFolderItems removeAllObjects];
	
	[currentPath release];
	
	// check if the path is end with "/"  
	if([[path substringWithRange:NSMakeRange([path length]-1,1)] compare:@"/"] == NSOrderedSame)
	{
		currentPath = [[NSString alloc] initWithFormat:@"%@",path];
	}
	else
	{
		currentPath = [[NSString alloc] initWithFormat:@"%@/",path];
	}
	
	int i;	// item in folder counter
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSInteger numberOfTotalItems = [[fileManager directoryContentsAtPath: currentPath] count];
	
	NSMutableArray *folders = [[NSMutableArray alloc] init];
	NSMutableArray *regularFiles = [[NSMutableArray alloc] init];
	
	for ( i = 0; i < numberOfTotalItems; i++ ) 
    {
		NSString* fileName = [[fileManager directoryContentsAtPath: currentPath]  objectAtIndex:i];
		
		NSMutableString* fileFullPath = [[NSMutableString alloc] initWithString: currentPath]; 
		[fileFullPath setString:[fileFullPath stringByAppendingPathComponent: fileName]];
		
		//NSDictionary* fileAttributes = [fileManager fileAttributesAtPath:fileFullPath traverseLink:YES];
		
		//checks if the item is directory
		BOOL isDir;
		BOOL fileExists = [fileManager fileExistsAtPath:fileFullPath isDirectory:&isDir];
		
		// check if it's hidden file
		BOOL isHidden = ([[fileName substringToIndex:1] compare:@"."] == NSOrderedSame);
		
		if(fileExists && !isHidden)
		{
			if(isDir)
				[folders addObject:[NSDictionary dictionaryWithObjectsAndKeys:
									fileName, @"fileName",
									@"directory", @"fileType",
									nil]];
			else
			{
				NSString* fileType = [self fileTypeOfFile:fileFullPath];
				[regularFiles addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										 fileName, @"fileName",
										 fileType, @"fileType", nil]];
			}
		}
		
		[ fileFullPath release ];
    }
	
	
	// group the folders and files
	[currentFolderItems  addObjectsFromArray:[folders arrayByAddingObjectsFromArray:regularFiles]];
	
	[folders release];
	[regularFiles release];
	
	[self.tableView reloadData];
	
	self.navigationItem.prompt = currentPath;
}

- (void)backClicked:(id)sender
{
	if( [currentPath compare:@"/"] != NSOrderedSame ) // if current path is not the root path "/"
	{
		[self refreshCurrentFolder:[currentPath stringByDeletingLastPathComponent]];
	}
}


- (UITableViewCell *)fileCellWithReuseIdentifier:(NSString *)identifier
{
#define ROW_HEIGHT 60

#define IMAGE_OFFSET 6.0
	
#define MIDDLE_COLUMN_OFFSET 60.0
#define MIDDLE_COLUMN_WIDTH 220.0
	
#define RIGHT_COLUMN_OFFSET 280.0
	
#define MAIN_FONT_SIZE 18.0
#define LABEL_HEIGHT 26.0
	
#define IMAGE_SIDE 48.0
	/*
	 Create an instance of UITableViewCell and add tagged subviews for the name, local time, and quarter image of the time zone.
	 */
	CGRect rect = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:identifier] autorelease];
	
	// Create image for the file
	rect = CGRectMake(IMAGE_OFFSET, (ROW_HEIGHT - IMAGE_SIDE) / 2.0, IMAGE_SIDE, IMAGE_SIDE);
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
	imageView.tag = IMAGE_TAG;
	[cell.contentView addSubview:imageView];
	[imageView release];
	
	/*
	 Create labels for the text fields; set the highlight color so that when the cell is selected it changes appropriately.
	 */
	UILabel *label;
	rect = CGRectMake(MIDDLE_COLUMN_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, MIDDLE_COLUMN_WIDTH, LABEL_HEIGHT);
	label = [[UILabel alloc] initWithFrame:rect];
	label.tag = NAME_TAG;
	label.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
	label.adjustsFontSizeToFitWidth = YES;
	[cell.contentView addSubview:label];
	label.highlightedTextColor = [UIColor whiteColor];
	[label release];	
	
	return cell;
}

-(NSString*) fileTypeOfFile:(NSString*) filePath
{
	NSString* fileExtension = [[filePath pathExtension] lowercaseString];
	
	if(	[fileExtension isEqualToString:@"png"])
		return @"PNG";
	
	if([fileExtension isEqualToString:@"jpg"] || [fileExtension isEqualToString:@"jpeg"])
		return @"JPEG";
	
	if( [fileExtension isEqualToString:@"tif"] || [fileExtension isEqualToString:@"tiff"] )
		return @"TIFF";
	
	if( [fileExtension isEqualToString:@"gif"] )
		return @"GIF";
	
	if([fileExtension isEqualToString:@"txt"] || [fileExtension isEqualToString:@"text"])
		return @"Text";
	
	if([fileExtension isEqualToString:@"rtf"])
		return @"Rich Text Format";
	
	if([fileExtension isEqualToString:@"pdf"])
		return @"PDF";
	
	if([fileExtension isEqualToString:@"zip"])
		return @"Archive";
	
	if([fileExtension isEqualToString:@"dmg"])
		return @"Disk Image";
	
	if([fileExtension isEqualToString:@"plist"])
		return @"Property List";
	
	if([fileExtension isEqualToString:@"xml"])
		return @"XML";
	
	if([fileExtension isEqualToString:@"m4v"] || [fileExtension isEqualToString:@"mp4"]
	   || [fileExtension isEqualToString:@"3gp"] || [fileExtension isEqualToString:@"mov"]
	   || [fileExtension isEqualToString:@"m4a"]
	   || [fileExtension isEqualToString:@"mpg"] || [fileExtension isEqualToString:@"mpeg"])
		return @"QuickTime Video";
	
/*	
  if([fileExtension isEqualToString:@"rmvb"] || [fileExtension isEqualToString:@"rm"]
	   || [fileExtension isEqualToString:@"wma"] || [fileExtension isEqualToString:@"avi"]
	   || [fileExtension isEqualToString:@"flv"])
		return @"VLC Video";
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if([fileManager isExecutableFileAtPath:filePath])
		return @"Executable";
	
	return @"Regular";
*/
  return @"VLC Video";
}

-(UIImage*) imageForFileType:(NSString*) fileType
{	
	if( [fileType isEqualToString:@"directory"])
		return [UIImage imageNamed:@"GenericFolderIcon_48.png"];
	
	if( [fileType isEqualToString:@"PNG"])
		return [UIImage imageNamed:@"png_64x64.png"];
	if( [fileType isEqualToString:@"JPEG"])
		return [UIImage imageNamed:@"jpeg_64x64.png"];
	if( [fileType isEqualToString:@"TIFF"])
		return [UIImage imageNamed:@"tiff_64x64.png"];
	if( [fileType isEqualToString:@"GIF"])
		return [UIImage imageNamed:@"gif_64x64.png"];
	
	if( [fileType compare:@"Text"] == NSOrderedSame )
		return [UIImage imageNamed:@"txt_48.png"];
	
	if( [fileType compare:@"Rich Text Format"] == NSOrderedSame )
		return [UIImage imageNamed:@"rtf_48.png"];
	
	if( [fileType isEqualToString:@"PDF"] )
		return [UIImage imageNamed:@"Generic_48.png"];
	
	if( [fileType compare:@"Archive"] == NSOrderedSame )
		return [UIImage imageNamed:@"Archive_48.png"];
	
	if( [fileType compare:@"Disk Image"] == NSOrderedSame )
		return [UIImage imageNamed:@"DiskImage_48.png"];
	
	if( [fileType compare:@"Property List"] == NSOrderedSame 
	   || [fileType compare:@"XML"] == NSOrderedSame)
		return [UIImage imageNamed:@"plist_64x64.png"];
	
	if( [fileType isEqualToString:@"Executable"])
		return [UIImage imageNamed:@"Executable_64x64.png"];
	
	if( [fileType isEqualToString:@"QuickTime Video"])
		return [UIImage imageNamed:@"Movie-QuickTime_48.png"];
	
	if( [fileType isEqualToString:@"VLC Video"])
		return [UIImage imageNamed:@"vlc_62.png"];
	
	return [UIImage imageNamed:@"GenericDocumentIcon_48.png"];
}


@end

