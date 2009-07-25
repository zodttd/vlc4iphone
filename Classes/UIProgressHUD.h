//
//  UIProgressHUD.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年3月25日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

@interface UIProgressHUD : NSObject
- (void) show: (BOOL) yesOrNo;
- (UIProgressHUD *) initWithWindow: (UIView *) window;
- (void) setText: (NSString *) theText;
@end
