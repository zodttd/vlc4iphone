//
//  PanVViewController.m
//  PanV
//
//  Created by nanotang on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PanVViewController.h"
#import "VideoStreamingAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation PanVViewController

@synthesize schedule, currentShow;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)viewWillAppear:(BOOL) animated{
	//NSLog(@"u:1");
	[super viewWillAppear:animated];
	
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor blackColor];
	self.view = contentView;
	[contentView release];
	
	//NSLog(@"u:2");

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//web view configuration for panv website
	panVView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	NSURL *panvlink = [NSURL URLWithString:@"http://m.panv.hk"];
	NSString *filetext = [NSString stringWithContentsOfURL:panvlink];
	[panVView loadHTMLString:filetext baseURL:panvlink];
	panVView.backgroundColor = [UIColor blackColor];
	panVView.scalesPageToFit = YES;
	panVView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	panVView.delegate = self;
	[self.view addSubview:panVView];
	
	//NSLog(@"u:3");

	//a UIView for cover the lower part of the website
	UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0.0, 263.0, 320.0, 237.0)];
	cover.backgroundColor = [UIColor blackColor];
	
	//a HeadUpView for current tv program display
	currentShow = [[HeadUpView alloc] initWithFrame:CGRectMake(20, 0, 280, 147)
															red:0.082 green:0.157 blue:0.188 radius:20.0];
	currentShow.alpha = 0.5;
	//a transparent display current tv program UITextView
	currentShowContent = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 240, 127)];
	currentShowContent.backgroundColor = [UIColor clearColor];	
	//currentShowContent.text = @"TVB:\n11:00-12:30 dlalf\nPearl:\n12:00-13:00 ldkajlfj\nATV:\n12:00-12:30 ldskajf\nWorld:\n12:00-14:00 slfkjl";
	currentShowContent.editable = NO;
	currentShowContent.textColor = [UIColor whiteColor];
	currentShowContent.font = [UIFont systemFontOfSize:10];
	
	//NSLog(@"u:4");

	[cover addSubview:currentShowContent];
	[cover addSubview:currentShow];
	
	[self.view addSubview:cover];
	[cover release];
	
	//NSLog(@"s:1");
	//a ScheduleViewController to display the full schedule of the 4 channels
	schedule = [[ScheduleViewController alloc] init];
	//NSLog(@"s:2");
	[self.view addSubview:schedule.view];
	//[schedule release];  if released, the view cannot be displayed
	
	//NSLog(@"1");
	//initialising the currentShowContent
	[self updateSchedule];

	//NSLog(@"2");
	//setting timer to update the currenShowContent automatically
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *aCalendar = [gregorian components:
								   (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) 
											   fromDate:today];
	//get next minutes which can be devided by 5
	NSInteger min = [aCalendar minute];
	min = (min/5)*5;
	[aCalendar setMinute:min];
	NSDate *firedDate = [gregorian dateFromComponents:aCalendar];
	firedDate = [firedDate addTimeInterval:5*60];
	//NSLog(@"firedDate: %@", [firedDate description]);
//	
//	NSLog(@"+++++++++++++++++++++++++++++access timeArray count: %d+++++++++++++++++++++++++++++++", [schedule.tvbSchedule.timeArray count]);
	
//	NSTimer *timer = [[NSTimer alloc] initWithFireDate:firedDate interval:5*60 target:self 
//									 selector:@selector(updateSchedule) 
//											  userInfo:nil repeats:YES];
	//[NSMutableArray arrayWithArray:self.schedule.tvbSchedule.timeArray]
	//works......if use this method
	//create a NSArray or NSDictionary to be passed to userInfo
	
	//NSDefaultRunLoopMode or NSRunLoopCommonModes no matter here
//	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//=======================Call vlc Player here============================================
//while iphone want to call its default player, it will cause errror as the default player doesn't support rtsp
//it will enter this method
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[UIApplication sharedApplication].isNetworkActivityIndicatorVisible = NO;
	//NSLog(@"enter fail function");
	NSString *errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[panVView loadHTMLString:errorString baseURL:nil];
}
//========================================================================================

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSUInteger numTaps = [[touches anyObject] tapCount];
	if(numTaps == 1){
		UITouch *touch = [touches anyObject];
		if([currentShow isEqual:[touch view]]){
			[schedule moveIn];
			currentShow.userInteractionEnabled = NO;
		}
		if([schedule.largeLayer isEqual:[touch view]]){
			[schedule moveOut];
			currentShow.userInteractionEnabled = YES;
		}
	}
}


-(void)updateSchedule{
		
//	NSLog(@"------------5 minutes: update current show schedule--------------");
	//NSLog(@"tvb current show------------------------");
	NSString *temp = [NSString stringWithFormat:@"TVB: %@-%@\n%@\n", [schedule.tvbSchedule getStartTime],
							   [schedule.tvbSchedule getEndTime], [schedule.tvbSchedule getCurrentProgram]];
	//NSLog(@"pearl current show------------------------");
	temp = [temp stringByAppendingFormat:@"Pearl: %@-%@\n%@\n", [schedule.pearlSchedule getStartTime],
			[schedule.pearlSchedule getEndTime], [schedule.pearlSchedule getCurrentProgram]];
	//NSLog(@"atv current show------------------------");
	temp = [temp stringByAppendingFormat:@"ATV: %@-%@\n%@\n", [schedule.atvSchedule getStartTime],
			[schedule.atvSchedule getEndTime], [schedule.atvSchedule getCurrentProgram]];
	//NSLog(@"world current show------------------------");
	temp = [temp stringByAppendingFormat:@"World: %@-%@\n%@\n", [schedule.worldSchedule getStartTime],
			[schedule.worldSchedule getEndTime], [schedule.worldSchedule getCurrentProgram]];
	
	currentShowContent.text = temp;
}

/*
-(void)autoUpdate:(NSTimer *)timer{
	ScheduleViewController *aSchedule = [myTimer userInfo];
	 //ScheduleViewController *controlObj = [[ScheduleViewController alloc] init];
	 if([aSchedule isMemberOfClass:[ScheduleViewController class]])
	 NSLog(@"userInfo is a member of Class Sch..Controller");
	 else
	 NSLog(@"userInfor is not a member of Class Sch..Controller");
	 //aSchedule = schedule;
	 if([aSchedule.tvbSchedule isMemberOfClass:[Schedule class]])
	 NSLog(@"userInfo is a member of Class Sch....");
	 else
	 NSLog(@"userInfor is not a member of Class Sch...");
	 //check timerArray property
	 if([aSchedule.tvbSchedule isMemberOfClass:[NSMutableArray class]])
	 NSLog(@"userInfo is a member of Class NSMutableArray....");
	 else
	 NSLog(@"userInfor is not a member of Class NSMutableArray...");
	 
	/////////////////testing//////////////////
	NSLog(@"fire...........");
	
	NSLog(@"fire: %@", schedule.tvbSchedule.channel);
	NSLog(@"fire: %d", [schedule.tvbSchedule.timeArray count]);
	NSString *temp = [NSString stringWithFormat:@"TVB: %@-%@\n%@\n", [schedule.tvbSchedule getStartTime],
					  [schedule.tvbSchedule getEndTime], [schedule.tvbSchedule getCurrentProgram]];
	
	//////////////////////////////////////////
	currentShowContent.text = temp;
	
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[panVView release];
	[currentShow release];
	[schedule release];
	[currentShowContent release];
	//[timer release];
    [super dealloc];
}


@end
