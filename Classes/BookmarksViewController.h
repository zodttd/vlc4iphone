//
//  BookmarksViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月4日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableEditorViewController;

@interface BookmarksViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView 	*tableView;
	NSMutableArray 			* bookmarksArray;
	TableEditorViewController *editViewController;
}

@property(nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray* bookmarksArray;
@property(nonatomic, retain) TableEditorViewController *editViewController;

-(void) addBookmarkWithPath:(NSString*)path;

@end
