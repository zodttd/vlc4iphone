//
//  RootViewController.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "VideoStreamingAppDelegate.h"
#import "RootViewController.h"
#import "LocalViewController.h"
#import "VideoListViewController.h"
#import	"CoverViewController.h"
#import "CoverFlowView.h"
#import "SettingViewController.h"
#import "BookmarksViewController.h"
#import "RecentsViewController.h"
#import "PanVViewController.h"
#import "VideoDetailViewController.h"
#import "NowPlayingViewController.h"

@implementation RootViewController

@synthesize localViewController;
@synthesize videoListViewController;
@synthesize settingViewController;
@synthesize bookmarksViewController;
@synthesize recentsViewController;
@synthesize panVViewController;
@synthesize nowPlayingViewController;
#pragma mark View delegate methods;

-(id) init
{
	if(self = [super init])
	{
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
		
		// initialize controllers
		self.localViewController = [[[LocalViewController alloc] initWithNibName:@"LocalView" bundle:nil] autorelease];
		self.videoListViewController = [[[VideoListViewController alloc] initWithNibName:@"VideoListView" bundle:nil] autorelease];		
		self.bookmarksViewController = [[[BookmarksViewController alloc] initWithNibName:@"BookmarksView" bundle:nil] autorelease];
		self.recentsViewController = [[[RecentsViewController alloc] initWithNibName:@"RecentsView" bundle:nil] autorelease];
		self.panVViewController = [[[PanVViewController alloc] init] autorelease];
		self.settingViewController = [[[SettingViewController alloc] initWithNibName:@"SettingsView"bundle:nil] autorelease];
		self.nowPlayingViewController = [[[NowPlayingViewController alloc] initWithNibName:@"NowPlaying" bundle:nil] autorelease];
		
		NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:6];
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.localViewController];
		localNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Local" image:[UIImage imageNamed:@"local_tabbar_ico.png"] tag:1];
		localNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		//localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.videoListViewController];
		//localNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Servers" image:[UIImage imageNamed:@"server_tabbar_ico.png"] tag:2];
		//localNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		//[localViewControllersArray addObject:localNavigationController];
		//[localNavigationController release];
		
		//panVViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"PanV" image:[UIImage imageNamed:@"panv_tabbar_ico.png"] tag:3];
		//[localViewControllersArray addObject:panVViewController];
		
		localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.bookmarksViewController];
		localNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:4]; 
		localNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.recentsViewController];
		localNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:5]; 
		localNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingViewController];
		localNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"setting_tabbar_ico.png"] tag:6];
		localNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		self.viewControllers = localViewControllersArray;
		self.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
				
		[localViewControllersArray release];
				
		self.moreNavigationController.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		
	}
	return self;
}

-(void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items
{
	UINavigationBar *nav = (UINavigationBar *) [[(UIView *) [self.view.subviews objectAtIndex:1] subviews] objectAtIndex:0];
	[nav setBarStyle:UIBarStyleBlackOpaque];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([videoListViewController.videoDetailViewController.view superview] ||
		[settingViewController.view superview] ||
		[panVViewController.view superview])
		return NO;
	
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[localViewController release];
    [settingViewController release];
    [videoListViewController release];
	[bookmarksViewController release];
	[panVViewController release];
	[recentsViewController release];
	[nowPlayingViewController release];
    [super dealloc];
}

@end
