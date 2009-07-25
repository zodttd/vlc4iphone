//
//  HeadUpView.m
//  PanV
//
//  Created by nanotang on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HeadUpView.h"
#import <QuartzCore/QuartzCore.h>


@implementation HeadUpView


- (void)fillRoundedRect:(CGRect)rect inContext:(CGContextRef)context
{
    //float radius = 5.0f;
    
    CGContextBeginPath(context);
	CGContextSetRGBFillColor(context, r, g, b, 1.0);
	//CGContextSetGrayFillColor(context, 0.8, 0.5);
	CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
	
    CGContextClosePath(context);
    CGContextFillPath(context);
}


- (id)initWithFrame:(CGRect)frame 
			red:(CGFloat)inputRed green:(CGFloat)inputGreen blue:(CGFloat)inputBlue 
			  radius:(CGFloat)inputRadius{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		r = inputRed;
		g = inputGreen;
		b = inputBlue;
		radius = inputRadius;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGRect boxRect = self.bounds;
    CGContextRef ctxt = UIGraphicsGetCurrentContext();	
	boxRect = CGRectInset(boxRect, 1.0f, 1.0f);
    [self fillRoundedRect:boxRect inContext:ctxt];
	self.backgroundColor = [UIColor clearColor];
}


- (void)dealloc {
    [super dealloc];
}


@end
