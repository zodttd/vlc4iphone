//
//  ScheduleViewController.h
//  PanV
//
//  Created by nanotang on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadUpView.h"
#import "Schedule.h"


@interface ScheduleViewController : UIViewController {
	HeadUpView *largeLayer;
	UITextView *tvbScheduleView;
	UITextView *pearlScheduleView;
	UITextView *atvScheduleView;
	UITextView *worldScheduleView;
	Schedule *tvbSchedule;
	Schedule *pearlSchedule;
	Schedule *atvSchedule;
	Schedule *worldSchedule;
	UIButton *tvbChannel;
	UIButton *pearlChannel;
	UIButton *atvChannel;
	UIButton *worldChannel;
	UIButton *exitSchedule;
}

@property (nonatomic, retain) Schedule *tvbSchedule;
@property (nonatomic, retain) Schedule *pearlSchedule;
@property (nonatomic, retain) Schedule *atvSchedule;
@property (nonatomic, retain) Schedule *worldSchedule;
@property (nonatomic, retain) HeadUpView *largeLayer;

-(void)moveIn;
-(void)moveOut;
-(void)changeToTVB;
-(void)changeToPearl;
-(void)changeToATV;
-(void)changeToWorld;

@end
