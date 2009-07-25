//
//  Schedule.h
//  PanV
//
//  Created by nanotang on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Schedule : NSObject {
	NSString *channel;
	NSMutableArray *timeArray;
	NSMutableArray *programArray;
}

@property (nonatomic, retain) NSString *channel;
@property (nonatomic, retain) NSMutableArray *timeArray;
@property (nonatomic, retain) NSMutableArray *programArray;

-(id)initWithChannel:(NSString *)chan;
//-(id)initWithChannel:(NSString *)chan time:(NSMutableArray *)timeArr program:(NSMutableArray *)programArr;
-(void)getTVBSchedule;
-(void)getATVSchedule;
-(NSString *)getCurrentProgram;
-(NSString *)getStartTime;
-(NSString *)getEndTime;
-(NSDate *)convertToDate:(NSString *)time;

@end
