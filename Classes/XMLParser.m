//
//  XMLParser.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年10月18日.
//  Copyright 2008 HKUST. All rights reserved.
//

#import "XMLParser.h"

static NSUInteger parsedVideoNodeCounter;

@implementation XMLParser

@synthesize currentVideoNode = _currentVideoNode, currentServer, videoNodes;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    parsedVideoNodeCounter = 0;
}

- (NSMutableArray*)parseXMLFileAtURL:(NSString *)serverURL xmlPath:(NSString *)path parseError:(NSError **)error
{
	currentServer = serverURL;
	
	NSURL *theURL = [NSURL URLWithString:[[@"http://" stringByAppendingString: serverURL] 
														stringByAppendingString:path]];
	
	videoNodes = [NSMutableArray array];
    NSXMLParser *parser = [[NSClassFromString(@"NSXMLParser") alloc] initWithContentsOfURL:theURL];
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }
    
    [parser release];
	[parseError release];

	return videoNodes;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }	
    
    if ([elementName isEqualToString:@"Video"]) {

        parsedVideoNodeCounter++;
		[self.currentVideoNode release];
		self.currentVideoNode = [[VideoNode alloc] init];
        [self.videoNodes addObject:self.currentVideoNode];
        return;
    }
	
    if ([elementName isEqualToString:@"title"]) {
        self.currentVideoNode.title = [attributeDict valueForKey: @"value"];
		self.currentVideoNode.serverPath = currentServer;
    } else if ([elementName isEqualToString:@"performer"]) {
        self.currentVideoNode.performer = [attributeDict valueForKey: @"value"];
    } else if ([elementName isEqualToString:@"seriesName"]) {
        self.currentVideoNode.seriesName = [attributeDict valueForKey: @"value"];
    } else if ([elementName isEqualToString:@"videoPath"]) {
        self.currentVideoNode.videoPath = [attributeDict valueForKey: @"value"];
    } else if ([elementName isEqualToString:@"imagePath"]) {
        self.currentVideoNode.imagePath = [attributeDict valueForKey: @"value"];
    } else if ([elementName isEqualToString:@"cellImagePath"]) {
        self.currentVideoNode.cellImagePath = [attributeDict valueForKey: @"value"];
    }	
}

- (void) dealloc
{
	//[videoNodes release];
	[currentServer release];
	[self.currentVideoNode release];
	[super dealloc];
}
@end
