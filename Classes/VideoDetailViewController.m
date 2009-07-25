/*

File: VideoDetailViewController.m
Abstract: Controller that manages the full tile view of the atomic information,
creating the reflection, and the flipping of the tile.

*/
#import "VideoNode.h"
 
#import "VideoDetailViewController.h"
#import "VideoDetailView.h"
#import "VideoDetailFlippedView.h"

@interface VideoDetailViewController(private)
-(UIImageView*)loadImageView;
@end


@implementation VideoDetailViewController
@synthesize video;

//@synthesize element;
@synthesize videoDetailFlippedView;
@synthesize videoDetailView;
@synthesize containerView;
@synthesize reflectionView;
@synthesize flipIndicatorButton;
@synthesize frontViewIsVisible;


#define reflectionFraction 0.35
#define reflectionOpacity 0.5

-(id)init:(VideoNode *)inputVideo
{
	if(self = [super init])
	{
		self.video = inputVideo;
		videoDetailView = nil;
		videoDetailFlippedView = nil;
		self.frontViewIsVisible=YES;
		self.hidesBottomBarWhenPushed = YES;
		self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	}
	return self;
}


- (void)loadView {	
	// create and store a container view

	UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.containerView = localContainerView;
	[localContainerView release];
	
	containerView.backgroundColor = [UIColor blackColor];
	
	//256 x 256
	CGSize preferredAtomicElementViewSize = [VideoDetailView preferredViewSize];
	
	CGRect viewRect = CGRectMake((containerView.bounds.size.width-preferredAtomicElementViewSize.width)/2,
								 (containerView.bounds.size.height-preferredAtomicElementViewSize.height)/2-40,
								 preferredAtomicElementViewSize.width,preferredAtomicElementViewSize.height);
	
	// create the atomic element view
	VideoDetailView *localAtomicElementView = [[VideoDetailView alloc] initWithFrame:viewRect videonode:video];
	self.videoDetailView = localAtomicElementView;
	[localAtomicElementView release];
	
	// add the video to the containerView
	videoDetailView.video = video;
	[containerView addSubview:videoDetailView];
	
	videoDetailView.viewController = self;
	self.view = containerView;
	
	// create the atomic element flipped view
	VideoDetailFlippedView *localAtomicElementFlippedView = [[VideoDetailFlippedView alloc] initWithFrame:viewRect];
	self.videoDetailFlippedView = localAtomicElementFlippedView;
	[localAtomicElementFlippedView release];

	videoDetailFlippedView.video = video;
	videoDetailFlippedView.viewController = self;


	// create the reflection view
	CGRect reflectionRect=viewRect;

	// the reflection is a fraction of the size of the view being reflected
	reflectionRect.size.height=reflectionRect.size.height*reflectionFraction;
	
	// and is offset to be at the bottom of the view being reflected
	reflectionRect=CGRectOffset(reflectionRect,0,viewRect.size.height);
	
	UIImageView *localReflectionImageView = [[UIImageView alloc] initWithFrame:reflectionRect];
	self.reflectionView = localReflectionImageView;
	[localReflectionImageView release];
	
	// determine the size of the reflection to create
	NSUInteger reflectionHeight=videoDetailView.bounds.size.height*reflectionFraction;
	
	// create the reflection image, assign it to the UIImageView and add the image view to the containerView
	reflectionView.image=[self.videoDetailView reflectedImageRepresentationWithHeight:reflectionHeight];
	reflectionView.alpha=reflectionOpacity;
	
	[containerView addSubview:reflectionView];

	
	UIButton *localFlipIndicator=[[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
	self.flipIndicatorButton=localFlipIndicator;
	[localFlipIndicator release];
	
	// front view is always visible at first
	[flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"flipper_list_black.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *flipButtonBarItem;
	flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipIndicatorButton];
	
	[self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
	[flipButtonBarItem release];
	
	[flipIndicatorButton addTarget:self action:@selector(flipCurrentView) forControlEvents:(UIControlEventTouchDown   )];
	 

}

- (void)flipCurrentView {
	NSUInteger reflectionHeight;
	UIImage *reflectedImage;
	
	// disable user interaction during the flip
	containerView.userInteractionEnabled = NO;
	flipIndicatorButton.userInteractionEnabled = NO;
	
	// setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (frontViewIsVisible==YES) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
        [videoDetailView removeFromSuperview];
        [containerView addSubview:videoDetailFlippedView];
		
		
		// update the reflection image for the new view
		reflectionHeight=videoDetailFlippedView.bounds.size.height*reflectionFraction;
		reflectedImage = [videoDetailFlippedView reflectedImageRepresentationWithHeight:reflectionHeight];
		reflectionView.image=reflectedImage;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
        [videoDetailFlippedView removeFromSuperview];
        [containerView addSubview:videoDetailView];
		// update the reflection image for the new view
		reflectionHeight=videoDetailView.bounds.size.height*reflectionFraction;
		reflectedImage = [videoDetailView reflectedImageRepresentationWithHeight:reflectionHeight];
		reflectionView.image=reflectedImage;
    }
	[UIView commitAnimations];
	
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];

	if (frontViewIsVisible==YES)
	{
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:video.flipperImageForVideoDetailViewNavigationItem forState:UIControlStateNormal];
	
	}
	else
	{
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"flipper_list_black.png"] forState:UIControlStateNormal];
		
	}
	[UIView commitAnimations];
	frontViewIsVisible=!frontViewIsVisible;
}


- (void)transitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	containerView.userInteractionEnabled = YES;
	flipIndicatorButton.userInteractionEnabled = YES;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[video release];
	
	[VideoDetailView release];
	[reflectionView release];
	[VideoDetailFlippedView release];
//	[element release];
	[super dealloc];
}


@end
