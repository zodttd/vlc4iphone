//
//  LocalViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月6日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocalViewController : UITableViewController {
	IBOutlet UITableView	*tableView;
	NSMutableArray			*currentFolderItems;
	NSString*				currentPath;
	BOOL					showHiddenFiles;
}

@property (nonatomic, retain) IBOutlet UITableView	*tableView;

- (void)backClicked:(id)sender;
- (void)refreshCurrentFolder:(NSString*)path;

@end
