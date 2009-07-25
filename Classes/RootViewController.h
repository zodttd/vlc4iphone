//
//  RootViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalViewController;
@class VideoListViewController;
@class SettingViewController;
@class BookmarksViewController;
@class RecentsViewController;
@class PanVViewController;
@class NowPlayingViewController;

@interface RootViewController : UITabBarController <UITabBarDelegate, UIActionSheetDelegate>{
	LocalViewController		*localViewController;
    VideoListViewController	*videoListViewController;
	SettingViewController 	*settingViewController;
	BookmarksViewController *bookmarksViewController;
	RecentsViewController 	*recentsViewController;
	PanVViewController		*panVViewController;
	NowPlayingViewController *nowPlayingViewController;
}

@property (nonatomic, retain) LocalViewController		*localViewController;
@property (nonatomic, retain) VideoListViewController	*videoListViewController;
@property (nonatomic, retain) SettingViewController		*settingViewController;
@property (nonatomic, retain) BookmarksViewController	*bookmarksViewController;
@property (nonatomic, retain) RecentsViewController		*recentsViewController;
@property (nonatomic, retain) PanVViewController		*panVViewController;
@property (nonatomic, retain) NowPlayingViewController 	*nowPlayingViewController;

@end
