//
//  LocalViewCell.m
//  VideoStreaming
//
//  Created by nanotang on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocalViewCell.h"


@implementation LocalViewCell

@synthesize icon, fileType, modifiedTime, more, title;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{	
	[super layoutSubviews];
    
    
    
//    // Start with a rect that is inset from the content view by 10 pixels on all sides.
    CGRect baseRect = CGRectInset(self.contentView.bounds, 10, 10);
    CGRect rect = baseRect;
    rect.origin.x += baseRect.size.width - 25;
    rect.origin.y += baseRect.size.height + 20;
    title.frame = rect;
//    // Position each label with a modified version of the base rect.
//    prompt.frame = rect;
//    rect.origin.x += 20;
//    rect.size.width = baseRect.size.width - 40;
//    name.frame = rect;
    
}

- (void)dealloc {
    [super dealloc];
}


@end
