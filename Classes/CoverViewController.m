#import "CoverViewController.h"
#import "VideoStreamingAppDelegate.h"
#import "VideoNode.h"

#define CVC_VIEW_TAG		32777

// *********************************************
// Extending UIView to reveal its heartbeat methods
// 
@interface UIView (extended)
- (void) startHeartbeat: (SEL) aSelector inRunLoopMode: (id) mode;
- (void) stopHeartbeat: (SEL) aSelector;
@end

// *********************************************
// The FlipView layer prevents touches from reaching the Coverflow layer behind it.
//
@interface FlipView : UIView
{
	UILabel *flipLabel;
}
@property (nonatomic, retain)		UILabel *flipLabel;
@end

@implementation FlipView
@synthesize flipLabel;

- (FlipView *) initWithFrame: (CGRect) aRect
{
	self = [super initWithFrame:aRect];
	
	// Add the flip label that shows the name and hex value
	self.flipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 480.0f, 480.0f)];
	self.flipLabel.textColor = [UIColor yellowColor];
	self.flipLabel.backgroundColor = [UIColor clearColor];
	self.flipLabel.textAlignment = UITextAlignmentCenter;
	self.flipLabel.font = [UIFont boldSystemFontOfSize:24.0f];
	self.flipLabel.userInteractionEnabled = NO;

	[self.flipLabel setNumberOfLines:2];
	[self addSubview:self.flipLabel];
	[self.flipLabel release];
	
	return self;
}

- (void) setText: (NSString *) theText
{
	self.flipLabel.text = theText;
}

// When touched, remove the label and unflip the swatch
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self removeFromSuperview];
	[(CoverFlowView *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:CVC_VIEW_TAG] flipSelectedCover];
}

- (void) dealloc
{
	[self.flipLabel release];
	[super dealloc];
}
@end


// to load image from server, given that the "path", eg. "video/pic1.jpg" is provided
id createImage(NSString *server, NSString *path) {
	NSURL *url = [NSURL URLWithString: [[[server stringByAppendingString: @"/"] stringByAppendingString: path] lowercaseString]]; 
//	UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


// *********************************************
// Coverflow View Controller
//
@implementation CoverViewController

@synthesize cfView;
@synthesize covers;
@synthesize titles;
@synthesize colorDict;
@synthesize whichItem;

- (CoverViewController *) init
{
	if (!(self = [super init])) return self;
	
//	NSArray *crayons = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crayons" ofType:@"txt"]] componentsSeparatedByString:@"\n"];
	self.covers = [[NSMutableArray alloc] init];
	self.titles = [[NSMutableArray alloc] init];
	self.colorDict = [[NSMutableDictionary alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//VideoStreamingAppDelegate* appDelegate2 = (VideoStreamingAppDelegate*) [[UIApplication sharedApplication] delegate];
	//int videoCount= appDelegate2.countOfVideoList; 
	//NSUInteger count = videoCount;
//	NSUInteger count = 0;
//
//	UIImage *coverImg;
//	while (count > 0) {
//		count--;
//		VideoStreamingAppDelegate* appDelegate = (VideoStreamingAppDelegate*) [[UIApplication sharedApplication] delegate];
//		VideoNode* video = [appDelegate objectInVideoListAtIndex:count];
//		[self.titles addObject:video.title]; //name
//		coverImg = createImage(@"http://derektse.no-ip.com:58080", video.imagePath);
//		[self.covers addObject:coverImg];//create image of corresponding color, using createImage function
//		[self.colorDict setObject:video.imagePath forKey:video.title];
//	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation]; 
	
	CGRect fliprect;
	CGFloat angle;
	// control the degree of rotation of the flipped label of the selected cover
	if (orientation == UIInterfaceOrientationLandscapeRight)
	{	// Create the flip object, the UILabel
		fliprect = CGRectMake(0.0f, 0.0f, 500.0f, 500.0f);
		angle = 3.141592f / 2.0f;
	} else if (orientation == UIInterfaceOrientationLandscapeLeft)
	{	// Create the flip object, the UILabel
		fliprect = CGRectMake(-200.0f, 10.0f, 500.0f, 500.0f);
		angle = 3.141592f *6.0f / 4.0f;
	}
	flippedView = [[FlipView alloc] initWithFrame:fliprect];
	[flippedView setTransform:CGAffineTransformMakeRotation(angle)];	
	[flippedView setUserInteractionEnabled:YES];
	
	// Initialize and Coverflow view to store the coverflow Layer
	self.cfView = [[CoverFlowView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] andCount:[self.titles count]];
	[self.cfView setUserInteractionEnabled:YES];
	[self.cfView setHost:self];
	
	// Finish setting up the cover flow layer
	self.whichItem = [self.titles count] / 2;
	[self.cfView.cfLayer selectCoverAtIndex:self.whichItem];
	[self.cfView.cfLayer setDelegate:self];
	
	selector = NULL;
	target = NULL;
	
	return self;
}	

// *********************************************
// Coverflow delegate methods
//
- (void) coverFlow: (id) coverFlow selectionDidChange: (int) index
{
	self.whichItem = index;
	[self.cfView.label setText:[self.titles objectAtIndex:index]];
}

// Detect the end of the flip -- both on reveal and hide
- (void) coverFlowFlipDidEnd: (UICoverFlowLayer *)coverFlow 
{
	if (flipOut)
		[[[UIApplication sharedApplication] keyWindow] addSubview:flippedView];
	else
		[flippedView removeFromSuperview];
}

// *********************************************
// Coverflow datasource methods
//

- (void) coverFlow:(id)coverFlow requestImageAtIndex: (int)index quality: (int)quality
{
	UIImage *whichImg = [self.covers objectAtIndex:index];
	[coverFlow setImage:[whichImg CGImage]  atIndex:index type:quality];
}

// Return a flip layer, one that preferably integrates into the flip presentation
- (id) coverFlow: (UICoverFlowLayer *)coverFlow requestFlipLayerAtIndex: (int) index
{
	if (flipOut) [flippedView removeFromSuperview];
	flipOut = !flipOut;
	
	// Prepare the flip text
	[flippedView setText:[NSString stringWithFormat:@"%@\n%@", [self.titles objectAtIndex:index], [self.colorDict objectForKey:[self.titles objectAtIndex:index]]]];
	
	// Flip with a simple blank square
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 140.0f)] autorelease];
//	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
	[view setBackgroundColor:[UIColor clearColor]];
	
	return [view layer];
}

// *********************************************
// Utility methods
//

- (int) selectedItem
{
	return self.whichItem;
}

- (void) start
{
	[self.cfView startHeartbeat: @selector(tick) inRunLoopMode: (id)kCFRunLoopDefaultMode];
	[self.cfView.cfLayer transitionIn:1.0f];
}

- (void) stop
{
	[self.cfView stopHeartbeat: @selector(tick)];
}

- (void) loadView
{
	[super loadView];
	self.view = self.cfView;
	[self start];
}

- (void) dealloc
{
	if (target) [target release];
	if (flippedView) [flippedView release];
	[self.cfView  release];
	[self.covers release];
	[self.titles release];
	[self.colorDict release];
	[super dealloc];
}

// *********************************************
// Callback method for double tap
//

- (void) doubleTapCallback
{
}

@end
