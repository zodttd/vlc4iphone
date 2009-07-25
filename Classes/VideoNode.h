//
//  VideoNode.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年10月18日.
//  Copyright 2008 HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoNode : NSObject //<NSCopying> 
{
	NSString* _title;
	NSString* _performer;
	NSString* _seriesName;
	NSString* _videoPath;
	NSString* _imagePath;
	NSString* _cellImagePath;
	NSString* _serverPath;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* performer;
@property (nonatomic, retain) NSString* seriesName;
@property (nonatomic, retain) NSString* videoPath;
@property (nonatomic, retain) NSString* imagePath;
@property (nonatomic, retain) NSString* cellImagePath;
@property (nonatomic, retain) NSString* serverPath;

@property (readonly) UIImage *flipperImageForVideoDetailViewNavigationItem;

@end
