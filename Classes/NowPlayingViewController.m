//
//  NowPlayingViewController.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月11日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//
//
#import "VideoStreamingAppDelegate.h"
#import "BookmarksViewController.h"
#import "RootViewController.h"
#import "NowPlayingViewController.h"
#import "VLCScreen.h"
#import <vlc/vlc.h>

@implementation NowPlayingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.navigationItem.title = @"Now Playing";
		self.navigationItem.hidesBackButton = YES;
		
		UIBarButtonItem *addBookmarkButton = [[[UIBarButtonItem alloc]
											initWithTitle:@"Add bookmark"
											style:UIBarButtonItemStyleBordered
											target:self action:@selector(addBookmark)] autorelease];
		
		self.navigationItem.rightBarButtonItem = addBookmarkButton; 
		
		self.view.opaque = YES;
		self.view.clearsContextBeforeDrawing = YES;
		
		screenView = [ [VLCScreen alloc] initWithFrame: CGRectMake(0, 0, 320, 240) ];
		[self.view addSubview: screenView];
    
    altAds = [[AltAds alloc] initWithFrame:CGRectMake(0.0f, 480.0f - 55.0f - 40.0f, 320.0f, 55.0f) andWindow:nil];
    [self.view addSubview:altAds];
	}
	return self;
}

/*
- (void)awakeFromNib {	

}
 */

/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
 - (void)viewDidLoad {
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {	
	[screenView release];
  [altAds release];
	[super dealloc];
}

- (void)volumeChanged:(id)sender
{
  //media_volume = (float)volumeSlider.value;
}

- (void)seekChanged:(id)sender
{
  media_seek = (float)seekSlider.value / 100.0f;
}

- (void)setCurrentlyPlaying:(NSString*) str
{
  [labelStation setText:str];
}

- (void)settingsClicked:(id)sender
{
	//[SOApp.delegate switchToSettings];
}

- (void)backClicked:(id)sender
{
	[self.view removeFromSuperview];
}

- (void)addBookmark:(id)sender
{
  if(strlen(media_file) > 0)
  {
    [appDelegate.rootViewController.bookmarksViewController addBookmarkWithPath:[NSString stringWithCString:media_file]];
  }
}

@end
