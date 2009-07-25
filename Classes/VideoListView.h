//
//  VideoListView.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListView : UITableView {
	//UINavigationBar* navigationBar;
	//UIBarButtonItem* barButton;
	UITableView* tableView;
}

//@property (nonatomic, retain) IBOutlet UINavigationBar* navigationBar;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButton;
@property (nonatomic, retain) IBOutlet UITableView* tableView;


@end
