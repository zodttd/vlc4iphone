#import "SettingView.h"

@implementation SettingView
@synthesize tableView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
	[tableView dealloc];
    [super dealloc];
}

@end
