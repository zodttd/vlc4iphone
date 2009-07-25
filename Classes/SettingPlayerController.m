//
//  SettingPlayerController.m
//  Categorize the Player Functions
//
//  Created by nanotang on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingPlayerController.h"
#import "SettingViewController.h"
#import "Constants.h"

@implementation SettingViewController (SettingPlayerController) 

- (void)create_UIControls
{
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"0", @"1", @"2", nil];
	CGRect frame = CGRectMake(0.0, 0.0, kSwitchButtonWidth, kSwitchButtonHeight);
	switchCtl1 = [[UISwitch alloc] initWithFrame:frame];
	switchCtl2 = [[UISwitch alloc] initWithFrame:frame];
	switchCtl3 = [[UISwitch alloc] initWithFrame:frame];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];

	frame = CGRectMake(-10.0, 0.0, kSegmentedControlWidth, kSegmentedControlHeight);
	segmentedControl.frame = frame;
	
	[switchCtl1 addTarget:self action:@selector(switchActionforSwitch1:) forControlEvents:UIControlEventValueChanged];
	[switchCtl2 addTarget:self action:@selector(switchActionforSwitch2:) forControlEvents:UIControlEventValueChanged];
	[switchCtl3 addTarget:self action:@selector(switchActionforSwitch3:) forControlEvents:UIControlEventValueChanged];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl1.backgroundColor = [UIColor clearColor];
	switchCtl2.backgroundColor = [UIColor clearColor];
	switchCtl3.backgroundColor = [UIColor clearColor];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

}

-(NSDictionary *) getDictionaryItem:(NSString *) name
{	
	NSDictionary *section = [data objectAtIndex:kPlayerSection];
	if (section) {
		NSDictionary *content = [section valueForKey:@"content"];
		if (content) {
			return [content valueForKey:name];
		}
	}
	return nil;
}

- (void)switchActionforSwitch1:(id)sender
{
	NSInteger index = [sender isOn];
	
	NSNumber *numberFromIndex = [NSNumber numberWithInteger:index];
	
	NSDictionary *item = [self getDictionaryItem:@"opt_ffmpegskipframe"];
	
	if (item) {
		[item setValue:[numberFromIndex stringValue] forKey:@"value"];
	}
	[self writeToUserPlist];
}

- (void)switchActionforSwitch2:(id)sender
{
	NSInteger index = [sender isOn];
	
	NSNumber *numberFromIndex = [NSNumber numberWithInteger:index];

	NSDictionary *item = [self getDictionaryItem:@"opt_noaudio"];
	
	if (item) {
		[item setValue:[numberFromIndex stringValue] forKey:@"value"];
	}
	[self writeToUserPlist];
}

- (void)switchActionforSwitch3:(id)sender
{
	NSInteger index = [sender isOn];
	
	NSNumber *numberFromIndex = [NSNumber numberWithInteger:index];

	NSDictionary *item = [self getDictionaryItem:@"opt_nodroplateframes"];
	
	if (item) {
		[item setValue:[numberFromIndex stringValue] forKey:@"value"];
	}
	[self writeToUserPlist];
}

- (void)segmentAction:(id)sender
{
	NSInteger index =[sender selectedSegmentIndex];
	
	NSNumber *numberFromIndex = [NSNumber numberWithInteger:index];

	NSDictionary *item = [self getDictionaryItem:@"opt_ffmpeglowres"];
	
	if (item) {
		[item setValue:[numberFromIndex stringValue] forKey:@"value"];
	}
	[self writeToUserPlist];
}


@end
