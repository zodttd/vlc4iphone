//
//  ScheduleViewController.m
//  PanV
//
//  Created by nanotang on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScheduleViewController

@synthesize tvbSchedule, pearlSchedule, atvSchedule, worldSchedule, largeLayer;

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
- (void)loadView {
	//getting the schedule from the official websites
//	NSLog(@"t:1");

	tvbSchedule = [[Schedule alloc] initWithChannel:@"jade"];
//	NSLog(@"t:2");
	pearlSchedule = [[Schedule alloc] initWithChannel:@"pearl"];
//	NSLog(@"t:3");
	atvSchedule = [[Schedule alloc] initWithChannel:@"atv"];
//	NSLog(@"t:4");
	worldSchedule = [[Schedule alloc] initWithChannel:@"world"];
//	NSLog(@"t:5");
	//the UITextView must be inside the screen to show the text in the animation. don't know why
	//initial frame: CGRectMake(270, 80, 280, 420)
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(270, 70, 280, 300)];
	self.view = contentView;
	//schedule initially invisible to users
	self.view.alpha = 0;
	[contentView release];
	
	largeLayer = [[HeadUpView alloc] initWithFrame:CGRectMake(0, 0, 280, 300) 
											   red:1 green:1 blue:1 radius:10];
	//invisible to user originally, change to visible when animating to show up
	largeLayer.alpha = 0.6;
	[self.view addSubview:largeLayer];
	//[largeLayer release];
	
	//the inner view of the schedule view
	UIView *smallLayer = [[UIView alloc] initWithFrame:CGRectMake(40, 10, 230, 270)];
	smallLayer.backgroundColor = [UIColor grayColor];
	smallLayer.alpha = 0.8;	
	[self.view addSubview:smallLayer];
	[smallLayer release];

	int i;
	//schedule view initialization-------------------------------------
	//tvb schedule view
	tvbScheduleView = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 230, 270)];
	tvbScheduleView.backgroundColor = [UIColor clearColor];
	tvbScheduleView.editable = NO;
	for(i=0; i<[tvbSchedule.timeArray count]; i++){
		tvbScheduleView.text = [tvbScheduleView.text stringByAppendingFormat:@"%@\n%@\n",
								[tvbSchedule.timeArray objectAtIndex:i], [tvbSchedule.programArray objectAtIndex:i]];
	}
	tvbScheduleView.textColor = [UIColor blueColor];
	[self.view addSubview:tvbScheduleView];
	
	//pearl schedule view
	pearlScheduleView = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 230, 270)];
	pearlScheduleView.backgroundColor = [UIColor clearColor];
	pearlScheduleView.editable = NO;
	for(i=0; i<[pearlSchedule.timeArray count]; i++){
		pearlScheduleView.text = [pearlScheduleView.text stringByAppendingFormat:@"%@\n%@\n",
								[pearlSchedule.timeArray objectAtIndex:i], [pearlSchedule.programArray objectAtIndex:i]];
	}
	pearlScheduleView.textColor = [UIColor blueColor];
	pearlScheduleView.alpha = 0;
	[self.view addSubview:pearlScheduleView];
	
	//atv schedule view
	atvScheduleView = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 230, 270)];
	atvScheduleView.backgroundColor = [UIColor clearColor];
	atvScheduleView.editable = NO;
	for(i=0; i<[atvSchedule.timeArray count]; i++){
		atvScheduleView.text = [atvScheduleView.text stringByAppendingFormat:@"%@\n%@\n",
								[atvSchedule.timeArray objectAtIndex:i], [atvSchedule.programArray objectAtIndex:i]];
	}
	atvScheduleView.textColor = [UIColor blueColor];
	atvScheduleView.alpha = 0;
	atvScheduleView.font = [UIFont systemFontOfSize:12];
	[self.view addSubview:atvScheduleView];
	
	//world schedule view
	worldScheduleView = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 230, 270)];
	worldScheduleView.backgroundColor = [UIColor clearColor];
	worldScheduleView.editable = NO;
	for(i=0; i<[worldSchedule.timeArray count]; i++){
		worldScheduleView.text = [worldScheduleView.text stringByAppendingFormat:@"%@\n%@\n",
								[worldSchedule.timeArray objectAtIndex:i], [worldSchedule.programArray objectAtIndex:i]];
	}
	worldScheduleView.textColor = [UIColor blueColor];
	worldScheduleView.alpha = 0;
	[self.view addSubview:worldScheduleView];
	
	//the default schedule is tvb schedule view-------------------------------------
	[self.view bringSubviewToFront:tvbScheduleView];
	
	//Button Initialization----------------------------------------------------------
	tvbChannel = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	tvbChannel.frame = CGRectMake(5, 10, 30, 30);
	tvbChannel.font = [UIFont systemFontOfSize:10];
	[tvbChannel setTitle:@"Jade" forState:UIControlStateNormal];
	[tvbChannel addTarget:self action:@selector(changeToTVB) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:tvbChannel];
	
	pearlChannel = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	pearlChannel.frame = CGRectMake(5, 45, 30, 30);
	pearlChannel.font = [UIFont systemFontOfSize:10];
	[pearlChannel setTitle:@"Pearl" forState:UIControlStateNormal];
	[pearlChannel addTarget:self action:@selector(changeToPearl) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:pearlChannel];
	
	atvChannel = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	atvChannel.frame = CGRectMake(5, 80, 30, 30);
	atvChannel.font = [UIFont systemFontOfSize:10];
	[atvChannel setTitle:@"ATV" forState:UIControlStateNormal];
	[atvChannel addTarget:self action:@selector(changeToATV) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:atvChannel];
	
	worldChannel = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	worldChannel.frame = CGRectMake(5, 115, 30, 30);
	worldChannel.font = [UIFont systemFontOfSize:10];
	[worldChannel setTitle:@"World" forState:UIControlStateNormal];
	[worldChannel addTarget:self action:@selector(changeToWorld) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:worldChannel];
	
	/*
	exitSchedule = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	exitSchedule.frame = CGRectMake(5, 150, 30, 30);
	exitSchedule.font = [UIFont systemFontOfSize:10];
	[exitSchedule setTitle:@"Exit" forState:UIControlStateNormal];
	[exitSchedule addTarget:self action:@selector(moveOut) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:exitSchedule];
	 */
}

-(void)moveIn{
	self.view.alpha = 1;
	CALayer *layer = self.view.layer;
	
	//the keyPath must be "position" to make the animation
	CAKeyframeAnimation *moveInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	moveInAnimation.removedOnCompletion = NO;
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, 460, 220);
	CGPathAddLineToPoint(path, NULL, 160, 220);
	
	moveInAnimation.path = path;
	moveInAnimation.duration = 1.0;
	moveInAnimation.delegate = self;
	//moveInAnimation.timingFunctions = (NSArray *)[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[layer addAnimation:moveInAnimation forKey:@"moveIn"];
	
	self.view.center = CGPointMake(160, 220);
	//self.view.transform = CGAffineTransformIdentity;
}

-(void)moveOut{
//	NSLog(@"enter move out method");
	CALayer *layer = self.view.layer;
	
	CAKeyframeAnimation *moveOutAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	moveOutAnimation.removedOnCompletion = NO;
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, 160, 220);
	CGPathAddLineToPoint(path, NULL, -140, 220);
	
	moveOutAnimation.path = path;
	moveOutAnimation.duration = 1.0;
	moveOutAnimation.delegate = self;
	[layer addAnimation:moveOutAnimation forKey:@"moveOut"];
	
	self.view.center = CGPointMake(410, 220);
}


-(void)animationDidStop:(CAAnimation *) theAnimation finished:(BOOL)flag{
//	NSLog(@"animation finished");
	if([theAnimation isEqual:[self.view.layer animationForKey:@"moveOut"]])
		self.view.alpha = 0;
//	else
		//NSLog(@"comparation failed");
}


-(void)changeToTVB{
	tvbScheduleView.alpha = 1;
	pearlScheduleView.alpha = 0;
	atvScheduleView.alpha = 0;
	worldScheduleView.alpha = 0;
	[self.view bringSubviewToFront:tvbScheduleView];
}

-(void)changeToPearl{	
	tvbScheduleView.alpha = 0;
	pearlScheduleView.alpha = 1;
	atvScheduleView.alpha = 0;
	worldScheduleView.alpha = 0;
	[self.view bringSubviewToFront:pearlScheduleView];
}

-(void)changeToATV{
	tvbScheduleView.alpha = 0;
	pearlScheduleView.alpha = 0;
	atvScheduleView.alpha = 1;
	worldScheduleView.alpha = 0;
	[self.view bringSubviewToFront:atvScheduleView];
}

-(void)changeToWorld{
	tvbScheduleView.alpha = 0;
	pearlScheduleView.alpha = 0;
	atvScheduleView.alpha = 0;
	worldScheduleView.alpha = 1;
	[self.view bringSubviewToFront:worldScheduleView];
}

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
	[largeLayer release];
	//[smallLayer release];
	//[tvbSchedule release];
	//[pearlSchedule release];
	//[atvSchedule release];
	//[worldSchedule release];
	
	[tvbScheduleView release];
	[pearlScheduleView release];
	[atvScheduleView release];
	[worldScheduleView release];
	
    [super dealloc];
}


@end
