//
//  NowPlayingViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月11日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "AltAds.h"

@class VLCScreen;

@interface NowPlayingViewController : UIViewController {
	IBOutlet	UISlider		* seekSlider;
	IBOutlet	UILabel			* labelStation;
	VLCScreen             * screenView;
  AltAds                * altAds;
}

- (void)volumeChanged:(id)sender;
- (void)setCurrentlyPlaying:(NSString*) str;
- (void)seekChanged:(id)sender;
//- (void)checkDisplay;
- (void)settingsClicked:(id)sender;
- (void)backClicked:(id)sender;
- (void)addBookmark:(id)sender;

@end
