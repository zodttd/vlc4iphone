//
//  SettingPlayerController.h
//  VideoStreaming
//
//  Created by nanotang on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"

@interface SettingViewController (SettingPlayerController)

- (void)create_UIControls;
-(NSDictionary *) getDictionaryItem:(NSString *) name;
@end
