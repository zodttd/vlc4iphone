//
//  HeadUpView.h
//  PanV
//
//  Created by nanotang on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HeadUpView : UIView {
	CGFloat r;
	CGFloat g;
	CGFloat b;
	CGFloat radius;
}

- (id)initWithFrame:(CGRect)frame 
			red:(CGFloat)inputRed green:(CGFloat)inputGreen blue:(CGFloat)inputBlue 
			 radius:(CGFloat)inputRadius;

@end
