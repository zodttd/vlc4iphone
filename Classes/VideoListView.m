//
//  VideoListView.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import "VideoListView.h"

@implementation VideoListView

//@synthesize navigationBar;
//@synthesize barButton;
@synthesize tableView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	//[barButton release];
	//[navigationBar release];
	[tableView release];
    [super dealloc];
}


@end
