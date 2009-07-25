//
//  LocalViewCell.h
//  VideoStreaming
//
//  Created by nanotang on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocalViewCell : UITableViewCell {
    UILabel* title;
    
    UILabel* fileType;
    UILabel* modifiedTime;
    UILabel* more;
    
    UIImageView* icon;
}

@property (nonatomic, retain) UILabel* title;
@property (nonatomic, retain) UILabel* fileType;
@property (nonatomic, retain) UILabel* modifiedTime;
@property (nonatomic, retain) UILabel* more;
@property (nonatomic, retain) UIImageView* icon;

@end
