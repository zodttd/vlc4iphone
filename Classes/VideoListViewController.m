//
//  VideoListViewController.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoDetailViewController.h"
#import "VideoStreamingAppDelegate.h"
#import "VideoDetailViewController.h"
#import "RootViewController.h"
#import "SettingViewController.h"
#import "XMLParser.h"
#import "UIProgressHUD.h"
#import "Constants.h"

@interface VideoListViewController(Private)

- (void)getVideoDataAtURL:(NSString*) serverURL xmlPath:(NSString*) path;
-(void)initializeAccelerometer;

@end

@implementation VideoListViewController

@synthesize videoURL, tableView, videoDetailViewController, videoListSection;

#pragma mark View Delegate Methods
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle 
{ 
    self = [super initWithNibName:nibName bundle:nibBundle]; 
    if (self) { 
        self.navigationItem.title = @"Video List";	
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target:self action:@selector(reloadTable)] autorelease] ;
    }
    return self; 
} 

-(void)viewWillDisappear:(BOOL) animated{
	[super viewWillDisappear:animated];
	selected = NO;
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	selected = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadVideoListFromServers];
	[self initializeAccelerometer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (UITableViewStyle)tableViewStyle {
	return UITableViewStylePlain;
}

- (void)dealloc {
	tableView.delegate = nil;
    tableView.dataSource = nil;
	[videoDetailViewController release];
	[tableView release];
	[videoListSection release];
	[oldIndexPath release];
	[videoURL release];
    [super dealloc];
}

#pragma mark UIAccelerometerDelegate Methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{   
	if (!selected) return;
	
	static NSInteger shakeCount=0;
	static NSDate *shakeStart;
	
	NSDate *now=[[NSDate alloc] init];
	//shaking within 2 sec
	NSDate *checkDate=[[NSDate alloc] initWithTimeInterval:2.0f sinceDate:shakeStart];
	
	//reset shake count if shaking interval exceed 2 sec
	if ([now compare:checkDate]==NSOrderedDescending||shakeStart==nil){
		shakeCount=0;
		[shakeStart release];
		shakeStart=[[NSDate alloc] init];                               
	}
	
	[now release];
	[checkDate release];
	
	//check x,y,z directions
//	if (fabsf(acceleration.x)>2.0 || fabsf(acceleration.y)>2.0|| fabsf(acceleration.z)>2.0){
	if (fabsf(acceleration.x)>kAccelerationThreshold){
		shakeCount++;
		
		//3 times within 2 sec
		if (shakeCount>2){
			//reset
			shakeCount=0;
			[shakeStart release];
			shakeStart=[[NSDate alloc] init];
			
			//reload table
			[self reloadTable];
		}
	}
}

#pragma mark TableView Delegate Methods
/*
 *  Data source - be aware that Apple has since rejected many applications that read this kind of
 *                data, so you  probably want to make a different choice for your own apps
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return ([self.videoListSection count] > 0) ? [self.videoListSection count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return ([self.videoListSection count] > 0)? [[self.videoListSection objectAtIndex:section] count] :0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self.videoListSection count] > 0) {
	
		NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
		[videoList addObjectsFromArray:[self.videoListSection objectAtIndex:section]];
		VideoNode* video = [videoList objectAtIndex:0];
		return video.serverPath;
		} else {
			return @"";
	}
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"any-cell"] autorelease];
	}
	
	NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
	[videoList addObjectsFromArray:[self.videoListSection objectAtIndex:indexPath.section]];
	
	VideoNode* video = [videoList objectAtIndex:indexPath.row];
	// Set up the cell
	cell.text = video.title;
	
	//catalog image is 60x60 pixels
	NSString* tempURL = [@"http://" stringByAppendingString:video.serverPath];
	NSURL *url = [NSURL URLWithString:[tempURL stringByAppendingString:video.cellImagePath]];
		
	UIImage *cellImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]] ;
	
	cell.image = cellImage;
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;	
	
	return cell;
}

/*
 *  Delegate Methods - This doesn't do anything, plus Apple has removed App launching from the SDK arsenal
 */

- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath 
{
	if(oldIndexPath != nil) {
//		NSLog(@"oldIndexPath is not null");
		[myTableView deselectRowAtIndexPath:oldIndexPath animated:YES];
	}
	oldIndexPath = newIndexPath;
	
	NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
	[videoList addObjectsFromArray:[self.videoListSection objectAtIndex:newIndexPath.section]];
	
	VideoNode* video = [videoList objectAtIndex:newIndexPath.row];

	NSString* videoUrl = [[@"http://" stringByAppendingString: video.serverPath] stringByAppendingString:video.videoPath];
		
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
	[appDelegate playVideoInDefaultPlayerWithPath:videoUrl usingURL:1];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
	[videoList addObjectsFromArray:[self.videoListSection objectAtIndex:indexPath.section]];
	
	VideoNode* video = [videoList objectAtIndex:indexPath.row];
	
	VideoDetailViewController *controller = [[VideoDetailViewController alloc] init:video];
	
	self.videoDetailViewController = controller;
	[[self navigationController] pushViewController:self.videoDetailViewController animated:YES];
	[controller release];
}

+ (NSIndexPath *)indexPathForRow:(NSUInteger)row inSection:(NSUInteger)section
{
	return nil;
}

#pragma mark BarItem Function

-(void) reloadTable
{
	[self removeAllVideos];
	[self loadVideoListFromServers];
}

#pragma mark Load Video List Methods

-(void) loadVideoListFromServers{
	SettingViewController* settingView = appDelegate.rootViewController.settingViewController;

	[appDelegate showProgressHUD];
		
	NSUInteger serverCount = [settingView countOfServers];
	NSInteger count =0;
		
	NSString* replace;
	
	[self.videoListSection release];
	self.videoListSection = [[NSMutableArray alloc] init];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	while (count < serverCount) {
		NSDictionary *section = [settingView.data objectAtIndex:kServerSection];
		NSMutableArray *content;
		NSDictionary *item;
		if (section) {
			content = [section valueForKey:@"content"];
			if (content) {
				item = (NSDictionary *)[content objectAtIndex:count];
				replace = [item valueForKey:@"Name"];
			}
		}
		
		NSArray *linkSplit = [replace componentsSeparatedByString:@"/"];
		
		NSArray *split = [[linkSplit objectAtIndex:0] componentsSeparatedByString:@":"];
		if ([appDelegate hostAvailable:[split objectAtIndex:0]]) {
			if ([replace length] >0) {
				[self getVideoDataAtURL:replace xmlPath:@"/video/test.xml"];
			}
		}
		else {
			[appDelegate alertSimpleAction:replace];
		}
		count++;
	
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.tableView reloadData];
}

- (void)getVideoDataAtURL:(NSString*) serverURL xmlPath:(NSString*) path
{	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSError *parseError = nil;
	
    XMLParser *streamingParser = [[XMLParser alloc] init];
	
	NSMutableArray *returnArray = [streamingParser parseXMLFileAtURL:serverURL xmlPath:path parseError:&parseError];
	
	NSMutableArray* videoList = [[NSMutableArray alloc] init];

	[videoList addObjectsFromArray:returnArray];

	[self.videoListSection addObject:videoList];

    [streamingParser release];
    [pool release];
}

#pragma mark other Methods

-(void) removeAllVideos
{
	[self.videoListSection removeAllObjects];
}

-(void) initializeAccelerometer
{
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
	//adjust the update interval if necessary
    accelerometer.updateInterval =  1.0f/30.0f;	
}

@end
