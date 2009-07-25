//
//  VideoStreamingAppDelegate.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "global.h"
#import "VideoStreamingAppDelegate.h"
#import "RootViewController.h"
#import "UIProgressHUD.h"
#import "VideoListViewController.h"
#import "RecentsViewController.h"
#import "SettingViewController.h"
#import "NowPlayingViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import <vlc/vlc.h>

/* Globals */
char media_file[1024];
int media_done = 0;
int media_playing = 0;
float media_seek = 0.0f;
float media_volume = 0.0f;
int media_audio = 0;

typedef struct CTX
{
  unsigned short* surf;
} CTX;

extern int iphone_main( int i_argc, const char *ppsz_argv[] );
extern unsigned short VideoBuffer[320*240];
extern unsigned short* VideoBaseAddress;
extern int iphone_exit;

static void lock(CTX *ctx, void **pp_ret)
{
  *pp_ret = ctx->surf;
}

static void unlock(CTX *ctx)
{
  //uint16_t *pixels = (uint16_t *)ctx->surf;
}

static void catch (libvlc_exception_t *ex)
{
  if(libvlc_exception_raised(ex))
  {
    fprintf(stderr, "exception: %s\n", libvlc_exception_get_message(ex));
    exit(1);
  }
  
  libvlc_exception_clear(ex);
}

@interface VideoStreamingAppDelegate(Private)
- (void) killProgressHUD:(id)aHUD;
-(void)myMoviePreloadFinish:(NSNotification*)aNotification;
-(void)myMovieFinishedCallback:(NSNotification*)aNotification;
-(void)app_Thread_Start;
@end

@implementation VideoStreamingAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize theMovie;

#pragma mark application delegate method
-(void) setupUserInterface
{
	UIWindow *localWindow;
	localWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = localWindow;
	
	// the localPortraitWindow data is now retained by the application delegate
	// so we can release the local variable
	[localWindow release];
	
	RootViewController *rvc = [[RootViewController alloc] init];
	
	self.rootViewController = rvc;
	[rvc release];
    [window addSubview:[rootViewController view]];
	[window setBackgroundColor:[UIColor blackColor]];
    [window makeKeyAndVisible];
	
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self setupUserInterface];
	
  //[NSThread setThreadPriority:1.0];
  [appDelegate.rootViewController.settingViewController loadAppSettings];
  media_audio = (NSOrderedSame == [[appDelegate.rootViewController.settingViewController getSetting:@"opt_noaudio"] compare:@"0"] ? 1 : 0);
  [NSThread detachNewThreadSelector:@selector(app_Thread_Start) toTarget:self withObject:nil];
	/*
  pthread_create(&main_tid, NULL, app_Thread_Start, NULL);
  struct sched_param    param;
  param.sched_priority = 63;
  if(pthread_setschedparam(main_tid, SCHED_RR, &param) != 0)
  {
    fprintf(stderr, "Error setting pthread priority\n");
  }
  */
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// remove movie notifications
  iphone_exit = 1;
	media_done = 1;
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerContentPreloadDidFinishNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:theMovie];  
}

- (void)dealloc {
	[theMovie release];
  [rootViewController release];
  [window release];
  [super dealloc];
}

#pragma mark UIProgressHUD controllers

- (void) killProgressHUD: (id) aHUD
{
	[aHUD show:NO];
	[aHUD release];
}

- (void) showProgressHUD
{
	id HUD = [[UIProgressHUD alloc] initWithWindow:self.window];
	[HUD setText:@"Updating..."];
	[HUD showInView:appDelegate.rootViewController.view];
	[self performSelector:@selector(killProgressHUD:) withObject:HUD afterDelay:1.5];
}

#pragma mark MoviePlayer Functions

-(void)myMoviePreloadFinish:(NSNotification*)aNotification
{
    
	MPMoviePlayerController* theMoviePlayer=[aNotification object];
    NSString *path = [[theMoviePlayer contentURL] absoluteString];

    if ([[aNotification userInfo] valueForKey:@"error"]) {
        //action: redirect to vlc
        
        
    } else {
        [appDelegate.rootViewController.recentsViewController addRecentWithPath:path];
        
        [theMoviePlayer play];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerContentPreloadDidFinishNotification object:nil];
        
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMoviePlayer=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMoviePlayer];
    [theMoviePlayer release];
}


#pragma mark Shared Application Methods
- (NSString*) getDocumentsDirectory
{
#if 0
	// Check for data in Documents directory. Copy default appData.plist to Documents if not found.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
#else
  return @"/Applications/vlc4iphone.app/";
#endif
}

- (void) playVideoInDefaultPlayerWithPath:(NSString*) path usingURL:(NSInteger)isURL
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMoviePreloadFinish:)
                                                 name:MPMoviePlayerContentPreloadDidFinishNotification
                                               object:nil];
    
    if(isURL)
      theMovie=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:path]];
    else
      theMovie=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie];

	
	theMovie.movieControlMode = MPMovieControlModeDefault;
	theMovie.scalingMode = MPMovieScalingModeAspectFill;	
}

-(void)app_Thread_Start
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  char clock[128], cunlock[128], cdata[128];
  char width[128], height[128], pitch[128];
  libvlc_exception_t ex;
  libvlc_instance_t *libvlc;
  libvlc_media_t *m;
  libvlc_media_player_t *mp;
  char const *vlc_argv[] =
  {
    //"-q",
    //"-vvvvv",
    "-I", "dummy",
    //"--plugin-path=/Applications/vlc4iphone.app/modules",
    "--ignore-config", /* Don't use VLC's config files */
    (media_audio ? "--aout=sdl" : "--no-audio"),
    "--vout=vmem",
    width,
    height,
    pitch,
    "--vmem-chroma=RV32",
    clock,
    cunlock,
    cdata,
  };
  int vlc_argc = sizeof(vlc_argv) / sizeof(*vlc_argv);

  CTX ctx;
  
  
  ctx.surf = VideoBaseAddress;
      
  /*
   *  Initialise libVLC
   */
  sprintf(clock, "--vmem-lock=%lld", (long long int)(intptr_t)lock);
  sprintf(cunlock, "--vmem-unlock=%lld", (long long int)(intptr_t)unlock);
  sprintf(cdata, "--vmem-data=%lld", (long long int)(intptr_t)&ctx);
  sprintf(width, "--vmem-width=%d", 320);
  sprintf(height, "--vmem-height=%d", 240);
  sprintf(pitch, "--vmem-pitch=%d", 320 * 4);
  
  libvlc_exception_init(&ex);
  libvlc = libvlc_new(vlc_argc, vlc_argv, &ex);
  //catch(&ex);
  /*
   *  Main loop
   */
  
  while(!iphone_exit)
  {
    int numloops = 0;
    
    while(!media_playing)
    {
      usleep(16666);
      sched_yield();      
    }
    m = libvlc_media_new(libvlc, media_file, &ex);
    //catch(&ex);
    mp = libvlc_media_player_new_from_media(m, &ex);
    //catch(&ex);
    libvlc_media_release(m);
    libvlc_media_player_play(mp, &ex);
    //catch(&ex);
    
    while(!media_done)
    {
      if(media_seek != 0.0f || media_volume != 0.0f)
      {
        if(media_seek)
        {
          libvlc_media_player_set_position(mp, media_seek, &ex);
          //catch(&ex);
          media_seek = 0.0f;
        }
        if(media_volume)
        {
          libvlc_audio_set_volume(libvlc, (int)(100.0f * media_volume), &ex);
          //catch(&ex);
          media_volume = 0.0f;
        }      
      }
            
      usleep(16666);
      sched_yield();
            
      numloops++;

      if(numloops > 120 && !(libvlc_media_player_is_playing(mp, &ex)))
      {
        /*
         * Stop stream and clean up libVLC
         */
        libvlc_media_player_stop(mp, &ex);
        //catch(&ex);
        
        libvlc_media_player_release(mp);  
        
        m = libvlc_media_new(libvlc, media_file, &ex);
        //catch(&ex);
        mp = libvlc_media_player_new_from_media(m, &ex);
        //catch(&ex);
        libvlc_media_release(m);
        libvlc_media_player_play(mp, &ex);
        //catch(&ex);
        numloops = 0;
      }
    }

    /*
     * Stop stream and clean up libVLC
     */
    libvlc_media_player_stop(mp, &ex);
    //catch(&ex);
    
    libvlc_media_player_release(mp);  
    
    media_done = 0;
    media_playing = 0;
  }
  libvlc_release(libvlc);
  
#if 0
	tArgv[tArgc] = (char*)malloc(strlen("/Applications/vlc4iphone.app/") + 1);
	sprintf(tArgv[tArgc], "/Applications/vlc4iphone.app/");
	tArgc++;
	tArgv[tArgc] = (char*)malloc(strlen("--intf=rc") + 1);
	sprintf(tArgv[tArgc], "--intf=rc");
	tArgc++;
	tArgv[tArgc] = (char*)malloc(strlen("--deinterlace-mode=disable") + 1);
	sprintf(tArgv[tArgc], "--deinterlace-mode=disable");
	tArgc++;
	tArgv[tArgc] = (char*)malloc(strlen("--text-renderer=dummy") + 1);
	sprintf(tArgv[tArgc], "--text-renderer=dummy");
	tArgc++;
	tArgv[tArgc] = (char*)malloc(strlen("--ffmpeg-skiploopfilter=4") + 1);
	sprintf(tArgv[tArgc], "--ffmpeg-skiploopfilter=4");
	tArgc++;
	tArgv[tArgc] = (char*)malloc(strlen("--file-caching=1000") + 1);
	sprintf(tArgv[tArgc], "--file-caching=1000");
	tArgc++;
	tArgv[tArgc] = (char*)malloc(strlen("--no-spu") + 1);
	sprintf(tArgv[tArgc], "--no-spu");
	tArgc++;
	
	if([[appDelegate.rootViewController.settingViewController getSetting:@"opt_ffmpegskipframe"] compare:@"1"] == NSOrderedSame)
	{
		tArgv[tArgc] = (char*)malloc(strlen("--ffmpeg-skip-frame=1") + 1);
		sprintf(tArgv[tArgc], "--ffmpeg-skip-frame=1");
		tArgc++;		
	}
	if([[appDelegate.rootViewController.settingViewController getSetting:@"opt_noaudio"] compare:@"1"] == NSOrderedSame)
	{
		tArgv[tArgc] = (char*)malloc(strlen("--no-audio") + 1);
		sprintf(tArgv[tArgc], "--no-audio");
		tArgc++;				
	}
	if([[appDelegate.rootViewController.settingViewController getSetting:@"opt_nodroplateframes"] compare:@"1"] == NSOrderedSame)
	{
		tArgv[tArgc] = (char*)malloc(strlen("--no-drop-late-frames") + 1);
		sprintf(tArgv[tArgc], "--no-drop-late-frames");
		tArgc++;		
	}
	if([[appDelegate.rootViewController.settingViewController getSetting:@"opt_ffmpeglowres"] compare:@"0"] == NSOrderedSame)
	{
		tArgv[tArgc] = (char*)malloc(strlen("--ffmpeg-lowres=0") + 1);
		sprintf(tArgv[tArgc], "--ffmpeg-lowres=0");
		tArgc++;
	}
	if([[appDelegate.rootViewController.settingViewController getSetting:@"opt_ffmpeglowres"] compare:@"1"] == NSOrderedSame)
	{
		tArgv[tArgc] = (char*)malloc(strlen("--ffmpeg-lowres=1") + 1);
		sprintf(tArgv[tArgc], "--ffmpeg-lowres=1");
		tArgc++;
	}
	if([[appDelegate.rootViewController.settingViewController getSetting:@"opt_ffmpeglowres"] compare:@"2"] == NSOrderedSame)
	{
		tArgv[tArgc] = (char*)malloc(strlen("--ffmpeg-lowres=2") + 1);
		sprintf(tArgv[tArgc], "--ffmpeg-lowres=2");
		tArgc++;
	}
#endif
  
  [pool release];
}

- (void) playVideoInVLCPlayerWithPath:(NSString*) path
{
	[self.window addSubview:self.rootViewController.nowPlayingViewController.view];
  [appDelegate.rootViewController.nowPlayingViewController setCurrentlyPlaying:path];
  [appDelegate.rootViewController.recentsViewController addRecentWithPath:path];
  
  if(media_playing)
  {
    int counter = 0;
    media_done = 1;
    while(media_done)
    {
      usleep(16666);
      sched_yield();
      counter++;
      if(counter >= 120)
      {
        break;
      }
    }
    
    media_done = 0;
    media_playing = 0;
  }
  
  sprintf(media_file, "%s", (char*) [path UTF8String]);
  
  media_playing = 1;
}

#pragma mark Network Connectivity
// Direct from Apple. Thank you Apple
- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0])];
	return addressString;
}

- (BOOL) hostAvailable: (NSString *) theHost
{
	
	NSString *addressString = [self getIPAddressForHost:theHost];
	if (!addressString) 
	{
		printf("Error recovering IP address from host name\n");
		return NO;
	}
	
	struct sockaddr_in address;
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	
	if (!gotAddress)
	{
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
		return NO;
	}
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) 
	{
		printf("Error. Could not recover network reachability flags\n");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	return isReachable ? YES : NO;;
}

#pragma mark UIAlertView

- (void)alertSimpleAction:(NSString*) serverURL
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Unreachable" message:serverURL
												   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// use "buttonIndex" to decide your action
	//
	
}

@end
