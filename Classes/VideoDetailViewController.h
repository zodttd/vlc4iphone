/*

File: VideoDetailViewController.h
Abstract: Controller that manages the full tile view of the atomic information,
creating the reflection, and the flipping of the tile.

*/

 
#import <UIKit/UIKit.h>

@class VideoDetailView;
@class VideoDetailFlippedView;

@class VideoNode;

@interface VideoDetailViewController : UIViewController {
	VideoNode *video;
	
	VideoDetailView *videoDetailView;
	VideoDetailFlippedView *videoDetailFlippedView;
	UIImageView *reflectionView;
	UIView *containerView;	
	UIButton *flipIndicatorButton;	
	BOOL frontViewIsVisible;
}

@property (nonatomic, retain)VideoNode *video;

@property (assign) BOOL frontViewIsVisible;
@property (nonatomic,retain) UIView *containerView;
@property (nonatomic,retain) VideoDetailView *videoDetailView;
@property (nonatomic,retain) UIImageView *reflectionView;
@property (nonatomic,retain) VideoDetailFlippedView *videoDetailFlippedView;
@property (nonatomic,retain) UIButton *flipIndicatorButton;


-(id)init:(VideoNode *)inputVideo;
- (void)flipCurrentView;
- (void)transitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
