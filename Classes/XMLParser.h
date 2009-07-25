//
//  XMLParser.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年10月18日.
//  Copyright 2008 HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoNode.h"

@interface XMLParser : NSObject{

@private 
	VideoNode* _currentVideoNode;
	NSString* currentServer;
	NSMutableArray* videoNodes;
}

@property (nonatomic, retain) VideoNode* currentVideoNode;
@property (nonatomic, retain) NSMutableArray* videoNodes;
@property (nonatomic, copy) NSString* currentServer;

- (NSMutableArray*)parseXMLFileAtURL:(NSString *)serverURL xmlPath:(NSString *)path parseError:(NSError **)error;

@end
