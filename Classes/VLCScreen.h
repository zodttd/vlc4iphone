//
//  VLCScreen.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月12日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreSurface/CoreSurface.h>
#import <QuartzCore/CALayer.h>

#import <unistd.h>
#import <sys/time.h>

@interface VLCScreen:UIView{
	CoreSurfaceBufferRef			_screenSurface;
	CALayer						*	screenLayer;
	NSTimer						*	timer;
}

- (id)initWithFrame:(struct CGRect)rect;
- (void)drawRect:(CGRect)rect;
- (CoreSurfaceBufferRef)getSurface;
@end
