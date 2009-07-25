/*

File: VideoDetailView.h
Abstract: Displays the Atomic Element information in a large format tile.

*/

 
#import <UIKit/UIKit.h>

@class VideoNode;
//@class AtomicElement;
@class VideoDetailViewController;

@interface VideoDetailView : UIView {
	VideoNode *video;

	VideoDetailViewController *viewController;
}

@property (nonatomic, retain) VideoNode *video;
@property (nonatomic, assign) VideoDetailViewController *viewController;

- (id)initWithFrame:(CGRect)frame videonode:(VideoNode*) videonode;
+ (CGSize)preferredViewSize;
- (UIImage *)reflectedImageRepresentationWithHeight:(NSUInteger)height;
@end
