#import <UIKit/UIKit.h>
#import "CoverFlowView.h"

@interface CoverViewController : UIViewController <CoverFlowHost> // protocol
{
	CoverFlowView		*cfView;
	NSMutableArray		*covers;
	NSMutableArray		*titles;
	int					whichItem;
	id					target;
	SEL					selector;
	
	NSMutableDictionary	*colorDict;
	UILabel				*flippedView; // flipped detail view
	BOOL				flipOut;
}
@property (nonatomic, retain)	CoverFlowView *cfView;
@property (nonatomic, retain)	NSMutableArray *covers;
@property (nonatomic, retain)	NSMutableArray *titles;
@property (nonatomic, retain)	NSMutableDictionary *colorDict;
@property						int whichItem;
@end
