//
//  Schedule.m
//  PanV
//
//  Created by nanotang on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Schedule.h"


@implementation Schedule

@synthesize channel, timeArray, programArray;

//chan must be one of "jade", "pearl", "atv", "world"
-(id)initWithChannel:(NSString *)chan{
	channel = chan;
	timeArray = [[NSMutableArray alloc] init];
	programArray = [[NSMutableArray alloc] init];
	if([channel isEqualToString:@"jade"] || [channel isEqualToString:@"pearl"])
		[self getTVBSchedule];
	else
		[self getATVSchedule];
	return self;
}

/*
-(id)initWithChannel:(NSString *)chan time:(NSMutableArray *)timeArr program:(NSMutableArray *)programArr{
	channel = chan;
	timeArray = [NSMutableArray arrayWithArray:timeArr];
	programArray = [NSMutableArray arrayWithArray:programArr];
	
	return self;
}
*/

-(void)getTVBSchedule{
	//NSLog(@"enter getTVBSchedule method");
	//get the current date string
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *aDayComponents = [gregorian components:
		(NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) 
													fromDate:today];
	if( [aDayComponents hour] < 6 )
		today = [today addTimeInterval:-24*3600];
	aDayComponents = [gregorian components:
		(NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) 
								  fromDate:today];
	
	//get day String
	NSInteger day = [aDayComponents day];	
	NSString *dayString;
	if(day<10)
		dayString = [NSString stringWithFormat:@"0%d", day];
	else
		dayString = [NSString stringWithFormat:@"%d", day];
	
	//get month string
	NSInteger month = [aDayComponents month];
	NSString *monthString;
	if(month<10)
		monthString = [NSString stringWithFormat:@"0%d", month];
	else
		monthString = [NSString stringWithFormat:@"%d", month];
		
	//NSLog(@"%d%@%@", [aDayComponents year], monthString, dayString);
	NSError **err;
	NSString *link = [NSString stringWithFormat:@"http://schedule.tvb.com/%@/%d%@%@.html?category=all", 
					  channel, [aDayComponents year], monthString, dayString];
	NSURL *url = [NSURL URLWithString:link];
	NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:err];
	
	NSArray *table = [html componentsSeparatedByString:@"id=\"content\""];
	table = [[table objectAtIndex:1] componentsSeparatedByString:@"</table>"];
	NSArray *tr = [[table objectAtIndex:0] componentsSeparatedByString:@"<td nowrap=\"nowrap\">"];
	
	for(int i=1; i<[tr count]; i++){
		NSArray *td = [[tr objectAtIndex:i] componentsSeparatedByString:@"<span style=\"float:left\">"];
		
		NSArray *timePart =[[td objectAtIndex:0] componentsSeparatedByString:@"</td>"];
		[timeArray addObject:[timePart objectAtIndex:0]];
		
		NSArray *programPart = [[td objectAtIndex:1] componentsSeparatedByString:@"<"];
		NSString *temp = [programPart objectAtIndex:0];
		while( [temp isEqualToString:@""]){
			programPart = [[programPart objectAtIndex:1] componentsSeparatedByString:@">"];
			temp = [programPart objectAtIndex:1];
		}
		temp = [temp stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
		[programArray addObject:temp];		
	}
}

-(void)getATVSchedule{
	NSError **err;
	NSURL *url;
	if([channel isEqualToString:@"atv"])
		url = [NSURL URLWithString:@"http://www.hkatv.com/v3/schedule/schedule-home.html"];
	else
		url = [NSURL URLWithString:@"http://www.hkatv.com/v3/schedule/schedule-world.html"];
//	NSLog(@"atv: 1");
	NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:err];
//	NSLog(@"atv: 2");
	
	//get the correct date
	//as the schedule starts from around 6am, thus even it's after midnight 12:00am
	//the schedule of previous day is still used
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayCalendar = [gregorian components:
										(NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) 
													fromDate:today];
	//testing==============
	//[weekdayCalendar setHour:22];
	//today = [today addTimeInterval:21*3600];
	//========================
//	NSLog(@"atv: 3");
	if( [weekdayCalendar hour] < 6 ){
		today = [today addTimeInterval:-24*3600];
	}
	NSLog([today description]);
	weekdayCalendar = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
	
	//get the correct weekday
	NSInteger aWeekday;
	if([weekdayCalendar weekday] == 1)
		aWeekday = 7;
	else
		aWeekday = [weekdayCalendar weekday]-1;
	
//	NSLog(@"weekday: %d", aWeekday);
	
	//extract schedule from html code
	NSString *separator1 = [NSString stringWithFormat:@"day%d", aWeekday];
	NSString *separator2 = [NSString stringWithFormat:@"</table>"];
	NSArray *table = [html componentsSeparatedByString:separator1];
	table = [[table objectAtIndex:1] componentsSeparatedByString:separator2];
	
	NSArray *tr = [[table objectAtIndex:0] componentsSeparatedByString:@".gif>"];
	NSString *period;
	//NSLog(@"========================Schedule=================================");
	for(int i=1; i<[tr count]-1; i++){
		NSArray *tempArray = [[tr objectAtIndex:i] componentsSeparatedByString:@"</td>"];
		NSString *row = [tempArray objectAtIndex:0];
		
		//removeing <...> of each row
		//NSLog(@"before: %@", row);
		NSRange start, end, removeRange;
		//NSLog(@"----------removing--------------");
		do{
			start = [row rangeOfString:@"<"];
			if( start.location != NSNotFound ){
				end = [row rangeOfString:@">"];
                if( end.location != NSNotFound ){
                    removeRange = NSMakeRange(start.location, end.location-start.location+1);
                    //NSLog(@"location: %d length: %d", start.location, end.location-start.location);
                    row = [row stringByReplacingCharactersInRange:removeRange withString:@" "];	
                    //NSLog(row);
                }
			}
		}while(start.location != NSNotFound && end.location != NSNotFound);
		//NSLog(@"----------end removing--------------");
		NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
		
		NSArray *byWhitespace = [row componentsSeparatedByCharactersInSet:set];
		NSString *firstPart = [byWhitespace objectAtIndex:0];
		//NSLog(@"----------%@--------------", firstPart);
		//NSLog(row);
		//setting time period
		if([firstPart isEqualToString:@"上午"])
			period = @" am";
		else if([firstPart isEqualToString:@"中午"])
			period = @" pm";
		else if([firstPart isEqualToString:@"午夜"])
			period = @" am";
		
		//if the first part is time, the length of time is 4 or 5
		else if ([firstPart length] == 4 || [firstPart length] == 5){
			NSString *timePart = firstPart;
			timePart = [timePart stringByAppendingString:period];
			[timeArray addObject:timePart];
			//NSLog(timePart);
			
			NSString *programPart = [row substringFromIndex:[firstPart length]];
			programPart = [programPart stringByTrimmingCharactersInSet:set];
			[programArray addObject:programPart];
			//NSLog(programPart);			
		}
		else ;
		//NSLog(@"==============================");
	}
	/*for(int j=0; j<[timeArray count]; j++){
		NSLog([timeArray objectAtIndex:j]);
		NSLog([programArray objectAtIndex:j]);
	}*/
	//NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
}


-(NSString *)getCurrentProgram{
	NSString *timeStr = [self getStartTime];
	NSInteger index = [timeArray indexOfObject:timeStr];
	if(index == NSNotFound)
		return nil;
	else
		return [programArray objectAtIndex:index];
}
										 
-(NSString *)getStartTime{
	//NSLog(@"getStartTime method Start********************************");
	//NSLog(@"timer:getStartTime: 1");
	NSInteger counter = [timeArray count]-1;
	//NSLog(@"timer:getStartTime: 2");
	NSDate *now = [NSDate date];
	NSDate *scheduleDate = [self convertToDate:[timeArray objectAtIndex:counter]];
	//NSLog(@"getStartTime: %@", [now description]);
	//NSLog(@"getStartTime: %@", [scheduleDate description]);
	while([now compare:scheduleDate] == NSOrderedAscending && counter > 0){
		counter--;
		//NSLog(@"getStartTime: %d", counter);
		scheduleDate = [self convertToDate:[timeArray objectAtIndex:counter]];
		//NSLog([scheduleDate description]);
	}
	//NSLog(@"getStartime method End********************************");
	return [timeArray objectAtIndex:counter];
}

-(NSString *)getEndTime{
	//NSLog(@"getEndTime method Start********************************");
	NSInteger counter = 0;
	NSDate *now = [NSDate date];
	NSDate *scheduleDate = [self convertToDate:[timeArray objectAtIndex:counter]];
	//NSLog(@"getEndTime start: %@", [now description]);
	//NSLog(@"getEndTime start: %@", [scheduleDate description]);
	while([now compare:scheduleDate] == NSOrderedDescending && counter < [timeArray count]-1){
		counter++;
		scheduleDate = [self convertToDate:[timeArray objectAtIndex:counter]];
		//NSLog(@"getEndTime: %d", counter);
		//NSLog([scheduleDate description]);
	}
	
	//NSLog(@"getEndTime method End********************************");
	return [timeArray objectAtIndex:counter];
}

-(NSDate *)convertToDate:(NSString *)time{
	//separating hour, minute and am/pm
	NSArray *apm = [time componentsSeparatedByCharactersInSet:
					[NSCharacterSet characterSetWithCharactersInString:@": "]];
	NSInteger modifiedHour = [[apm objectAtIndex:0] integerValue];
	//normalize the time to be 24 hours based
	if([[apm objectAtIndex:2] isEqualToString:@"pm"]){
		if(modifiedHour != 12)
			modifiedHour += 12;
	}
	else{
		if(modifiedHour == 12)
			modifiedHour = 0;
	}
	
	NSInteger modifiedMinute = [[apm objectAtIndex:1] integerValue];		
	
	//there are 4 conditions here
	//input time can be today or next day, from the schedule.timeArray
	//[NSDate date can be today or next day, it's the current/real time
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *aCalendar = [gregorian components:
		(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) 
					fromDate:today];
	
	//NSLog(@"real time: %d, input tiem: %d", [aCalendar hour], modifiedHour);
	//NSDate must be changed before the NSDateComponent as it's created by NSDateComponent
	//both times are on the next day, the input time can be converted correctly
	
	if([channel isEqualToString:@"jade"] || [channel isEqualToString:@"pearl"]){
		//if real time is on next day, input time is on today. NSDate - 1 day
		if( [aCalendar hour] < 6 && modifiedHour >= 6 )
			today = [today addTimeInterval:-24*3600];
	
		//if real time is on today, input time is on next day, NSDate + 1 day
		if( [aCalendar hour] >= 6 && modifiedHour < 6 )
			today = [today addTimeInterval:24*3600];
	}
	//atv's program start at 5am
	else{
		//if real time is on next day, input time is on today. NSDate - 1 day
		if( [aCalendar hour] < 5 && modifiedHour >= 5 )
			today = [today addTimeInterval:-24*3600];
	
		//if real time is on today, input time is on next day, NSDate + 1 day
		if( [aCalendar hour] >= 5 && modifiedHour < 5 )
			today = [today addTimeInterval:24*3600];
	}
	//set the input time to NSDateComponent
	aCalendar = [gregorian components:
				 (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) 
							 fromDate:today];
	[aCalendar setHour:modifiedHour];
	[aCalendar setMinute:modifiedMinute];
		
	NSDate *modifiedDate = [gregorian dateFromComponents:aCalendar];
	//NSLog([modifiedDate description]);
	//NSLog([today description]);
	return modifiedDate;
}

-(void)dealloc{
	[channel release];
	[timeArray release];
	[programArray release];
	
	[super dealloc];
}

@end
