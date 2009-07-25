//
//  VideoNode.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年10月18日.
//  Copyright 2008 HKUST. All rights reserved.
//

#import "VideoNode.h"


@implementation VideoNode

@synthesize title = _title;
@synthesize performer = _performer;
@synthesize seriesName = _seriesName;
@synthesize videoPath = _videoPath;
@synthesize imagePath = _imagePath;
@synthesize cellImagePath = _cellImagePath;
@synthesize serverPath = _serverPath;

- (void) dealloc
{
	[self.title release];
	[self.performer release];
	[self.seriesName release];
	[self.videoPath release];
	[self.imagePath release];
	[self.serverPath release];
	[self.cellImagePath release];
	[super dealloc];
}
//
//-(id) initWithVideoNode:(VideoNode*) inputNode
//{
//	self = [super init];
//	if (self)
//	{
//		self.title = inputNode.title;
//		self.performer = inputNode.performer;
//		self.seriesName = inputNode.seriesName;
//	}
//	return self;
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    VideoNode *copy = [[[self class] allocWithZone: zone]
//					 					 initWithVideoNode:self];
//	
//    return copy;
//}
- (UIImage *)flipperImageForVideoDetailViewNavigationItem {
	
	// return a 30 x 30 image that is a reduced version
	// of the AtomicElementTileView content
	// this is used to display the flipper button in the navigation bar
	CGSize itemSize=CGSizeMake(30.0,30.0);
	CGRect elementSymbolRectangle = CGRectMake(0,0, itemSize.width, itemSize.height);
	UIGraphicsBeginImageContext(itemSize);
		
	// retrieve the image url
	NSString* tempURL = [NSString stringWithFormat:@"http://%@", self.serverPath];
	NSURL *url = [NSURL URLWithString:[tempURL stringByAppendingString:self.cellImagePath]];
	
	// create the video image
	UIImage *videoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	[videoImage drawInRect:elementSymbolRectangle];
	
	// obtain the image context
	UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

@end
