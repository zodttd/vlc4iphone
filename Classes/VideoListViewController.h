//
//  VideoListViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 08年9月25日.
//  Copyright HKUST 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class VideoDetailViewController;

@interface VideoListViewController : UITableViewController <UISearchBarDelegate, UIAccelerometerDelegate,
															UINavigationBarDelegate,
															UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	NSIndexPath *oldIndexPath;
    NSURL* videoURL;
	NSMutableArray *videoListSection;
	BOOL selected;
	
	VideoDetailViewController* videoDetailViewController;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSURL* videoURL;
@property (nonatomic, retain) NSMutableArray *videoListSection;
@property (nonatomic, retain) VideoDetailViewController* videoDetailViewController;

-(void) loadVideoListFromServers;
-(void) removeAllVideos;
-(void) reloadTable;
@end
