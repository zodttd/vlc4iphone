//
//  VideoStreamingAppDelegate.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

#define appDelegate ((VideoStreamingAppDelegate*)[[UIApplication sharedApplication] delegate])

extern char media_file[1024];
extern int media_done;
extern int media_playing;
extern float media_seek;
extern float media_volume;
extern void *app_Thread_Start(void *args);

@class MPMoviePlayerController;
@class UIProgressHUD;
@class RootViewController;
@class VideoListViewController;
@class NowPlayingViewController;

@interface VideoStreamingAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
	UIWindow *window;
	RootViewController *rootViewController;
	MPMoviePlayerController* theMovie;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) MPMoviePlayerController* theMovie;

-(BOOL) hostAvailable: (NSString *) theHost;
-(void)alertSimpleAction:(NSString*) serverURL;

- (void) showProgressHUD;

- (NSString*) getDocumentsDirectory;

- (void) playVideoInDefaultPlayerWithPath:(NSString*) path usingURL:(NSInteger)isURL;
- (void) playVideoInVLCPlayerWithPath:(NSString*) path;
@end

