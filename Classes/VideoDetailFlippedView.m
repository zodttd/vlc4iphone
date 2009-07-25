/*

File: VideoDetailFlippedView.m
Abstract: Displays the Atomic Element information with a link to Wikipedia.

*/

#import "VideoDetailView.h"
#import "VideoNode.h"
//#import "AtomicElement.h"
//#import "PeriodicElements.h"
#import "VideoDetailFlippedView.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation VideoDetailFlippedView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
	{
		[self setAutoresizesSubviews:YES];
		
		// set the background color of the view to clear
		self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	// get the background image for the state of the element
	// position it appropriately and draw the image
	UIImage *backgroundImage = [UIImage imageNamed:@"Liquid.png"];
	CGRect elementSymbolRectangle = CGRectMake(0,0, [backgroundImage size].width, [backgroundImage size].height);
	[backgroundImage drawInRect:elementSymbolRectangle];
	
	// all the text is drawn in white
	//Sets the color of subsequent stroke and fill operations to the color that the receiver represents.
	[[UIColor whiteColor] set];
	
	// draw the Title
	UIFont *font = ([video.title length] < 15) ? [UIFont boldSystemFontOfSize:36]:
													[UIFont boldSystemFontOfSize:30];
	CGSize stringSize = [video.title sizeWithFont:font];
	CGPoint point = CGPointMake((self.bounds.size.width-stringSize.width)/2,50);
	[video.title drawAtPoint:point withFont:font];
	
	float verticalStartingPoint=95;
	
	// draw the Performer(s)
	font = [UIFont boldSystemFontOfSize:14];
	NSString *performerString=[NSString stringWithFormat:@"Performer(s): %@",video.performer];
	stringSize = [performerString sizeWithFont:font];
	point = CGPointMake((self.bounds.size.width-stringSize.width)/2,verticalStartingPoint);
	[performerString drawAtPoint:point withFont:font];
	
	// draw the Video Path
	font = ([video.videoPath length] < 26) ? [UIFont boldSystemFontOfSize:14]:
												[UIFont boldSystemFontOfSize:13];
	NSString *videoPathString=[NSString stringWithFormat:@"Video: %@",[video.videoPath lastPathComponent]];
	stringSize = [videoPathString sizeWithFont:font];
	point = CGPointMake((self.bounds.size.width-stringSize.width)/2,verticalStartingPoint+20);
	[videoPathString drawAtPoint:point withFont:font];
	
	// draw the Image Path
	font = ([video.imagePath length] < 26) ? [UIFont boldSystemFontOfSize:14]:
												[UIFont boldSystemFontOfSize:13];
	NSString *imagePathString=[NSString stringWithFormat:@"Image: %@",[video.imagePath lastPathComponent]];
	stringSize = [imagePathString sizeWithFont:font];
	point = CGPointMake((self.bounds.size.width-stringSize.width)/2,verticalStartingPoint+40);
	[imagePathString drawAtPoint:point withFont:font];

	// draw the Server
	font = [UIFont boldSystemFontOfSize:14];
	NSString *serverString=[NSString stringWithFormat:@"Server: %@",video.serverPath];
	stringSize = [serverString sizeWithFont:font];
	point = CGPointMake((self.bounds.size.width-stringSize.width)/2,verticalStartingPoint+60);
	[serverString drawAtPoint:point withFont:font];
	
	// draw the Series Name
	font = [UIFont boldSystemFontOfSize:24];
	NSString *seriesNameString = video.seriesName;
	stringSize = [seriesNameString sizeWithFont:font];
	point = CGPointMake((self.bounds.size.width-stringSize.width)/2,verticalStartingPoint+100);
	[seriesNameString drawAtPoint:point withFont:font];
	
}

- (void)dealloc {
	[super dealloc];
}

@end
