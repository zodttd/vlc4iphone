//
//  VLCScreen.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月12日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import "VLCScreen.h"
#import <CoreSurface/CoreSurface.h>
#import <IOKit/IOKitLib.h>
#import <time.h>
#import <sched.h>

unsigned short VideoBuffer[320*240];
unsigned short* VideoBaseAddress = NULL;
int iphone_exit = 0;

@implementation VLCScreen
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])!=nil) {
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		[[self layer] setMinificationFilter: 0];
		[[self layer] setMagnificationFilter:0];
		
		CFMutableDictionaryRef dict;
		int w = 320; //rect.size.width;
		int h = 240; //rect.size.height;
		
    int pitch = w * 4, allocSize = 4 * w * h;
    char *pixelFormat = "ARGB";
		
		dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
										 &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
		CFDictionarySetValue(dict, kCoreSurfaceBufferGlobal, kCFBooleanTrue);
		CFDictionarySetValue(dict, kCoreSurfaceBufferMemoryRegion,
							 @"IOSurfaceMemoryRegion");
		CFDictionarySetValue(dict, kCoreSurfaceBufferPitch,
							 CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pitch));
		CFDictionarySetValue(dict, kCoreSurfaceBufferWidth,
							 CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &w));
		CFDictionarySetValue(dict, kCoreSurfaceBufferHeight,
							 CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &h));
		CFDictionarySetValue(dict, kCoreSurfaceBufferPixelFormat,
							 CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, pixelFormat));
		CFDictionarySetValue(dict, kCoreSurfaceBufferAllocSize,
							 CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &allocSize));
		
		_screenSurface = CoreSurfaceBufferCreate(dict);
		CoreSurfaceBufferLock(_screenSurface, 3);
		
    	//CALayer* screenLayer = [CALayer layer];  
		screenLayer = [[CALayer layer] retain];
		screenLayer.frame = CGRectMake(0.0f, 0.0f, 320.0f, 238.0f);
		[screenLayer setOpaque: YES];
		[screenLayer setMinificationFilter: 0];
		[screenLayer setMagnificationFilter: 0];
		screenLayer.contents = (id)_screenSurface;
		[[self layer] addSublayer:screenLayer];
		
    	CoreSurfaceBufferUnlock(_screenSurface);
		
		VideoBaseAddress = (unsigned short*)CoreSurfaceBufferGetBaseAddress(_screenSurface);
		
    [NSThread detachNewThreadSelector:@selector(updateScreen) toTarget:self withObject:nil];
    /*
		timer = [NSTimer scheduledTimerWithTimeInterval:(1.0f / 30.0f)
												 target:self
											   selector:@selector(setNeedsDisplay)
											   userInfo:nil
												repeats:YES];
    */
	}
    
	return self;
}

- (void)updateScreen
{
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  while(!iphone_exit)
  {
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
    usleep(100000);
    //sched_yield();
  }
  [pool release];
}

- (void)dealloc
{
	//[timer invalidate];
	//[ screenLayer release ];
	[ super dealloc ];
}

- (CoreSurfaceBufferRef)getSurface
{
	return _screenSurface;
}

- (void)drawRect:(CGRect)rect
{
#if 0
	unsigned char* videobuffer = set_iphone_video_buffer(NULL);
	if(videobuffer == NULL)
	{
		return;
	}
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGImageRef renderImage = CGImageCreate(
										   320,
										   240,
										   8,
										   32,
										   320 * 4,
										   CGColorSpaceCreateDeviceRGB(),
										   kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst,
										   CGDataProviderCreateWithData( NULL, videobuffer, 320*240*4, NULL ),
										   NULL,
										   0,
										   kCGRenderingIntentDefault
										   );
	
	CGContextScaleCTM(ctx, 1.0f, -1.0f);  
	CGContextTranslateCTM(ctx, 0.0f, -240.0f);
	
    CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 320, 240), renderImage );
	
	CFRelease(renderImage);
#else
  
#endif
}

@end
