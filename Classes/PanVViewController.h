//
//  PanVViewController.h
//  PanV
//
//  Created by nanotang on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadUpView.h"
#import "ScheduleViewController.h"
#import "Schedule.h"


@interface PanVViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *panVView;
	HeadUpView *currentShow;
	ScheduleViewController *schedule;
	UITextView *currentShowContent;
	//NSTimer *timer;
}

@property (nonatomic, retain) ScheduleViewController *schedule;
@property (nonatomic, retain) HeadUpView *currentShow;
//@property (nonatomic, retain) NSTimer *timer;

-(void)updateSchedule;
//-(void)autoUpdate:(NSTimer *)timer;

@end
