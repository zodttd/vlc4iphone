//
//  RecentsViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月6日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView 	*tableView;
	NSMutableArray 			*recentsArray;
}

@property(nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray* recentsArray;

-(void) addRecentWithPath:(NSString*)path;
@end
