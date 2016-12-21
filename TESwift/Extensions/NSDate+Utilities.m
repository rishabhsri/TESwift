//
//  NSDate+Utilities.m
//  SignUpMod
//
//  Created by Nipur Garg on 7/29/15.
//  Copyright (c) 2015 VGroup Inc. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)


+ (BOOL) isEmpty:(NSString *)string{
    
    if([string isKindOfClass:[NSNull class]])
        return YES;
    else if(string == nil)
        return YES;
    
    else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
        return YES;
    else
        return NO;
    
}

+ (NSString*)getTimeDiffSinceDate:(NSDate*)date 
{
    return [[NSDate date] getTimestampSinceDate:date withFormat:nil];
}

- (NSString*)getTimestampSinceDate:(NSDate*)date withFormat:(NSString *)format
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekOfMonthCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSDateComponents *components = [calendar components:unitFlags fromDate:earliest toDate:latest options:0];
    
    if (!format) {
      //  format = @"%i %u %c";
        format = @"%i %u";
    }
    
    if (components.year >= 1) {
        return NSLocalizedString(@"over a year ago", nil);
    }
    if (components.month >= 1) {
        return [self stringForComponentValue:components.month withName:@"month" andPlural:@"months" format:format];
    }
//    if (components.week >= 1) {
//        return [self stringForComponentValue:components.week withName:@"week" andPlural:@"weeks" format:format];
//    }
    if (components.weekOfMonth >= 1) {
        return [self stringForComponentValue:components.weekOfMonth withName:@"week" andPlural:@"weeks" format:format];
    }
    if (components.day >= 1) {
        return [self stringForComponentValue:components.day withName:@"day" andPlural:@"days" format:format];
    }
    if (components.hour >= 1) {
        return [self stringForComponentValue:components.hour withName:@"hr" andPlural:@"hr" format:format];
    }
    if (components.minute >= 1) {
        return [self stringForComponentValue:components.minute withName:@"min" andPlural:@"min" format:format];
    }
    return NSLocalizedString(@"just now", nil);
}


- (NSString*)stringForComponentValue:(NSInteger)componentValue withName:(NSString*)name andPlural:(NSString*)plural format:(NSString*)format
{
    NSString *timespan = NSLocalizedString(componentValue == 1 ? name : plural, nil);
    
    NSMutableString *output = format.mutableCopy;
    [output replaceOccurrencesOfString:@"%i" withString:@(componentValue).stringValue options:0 range:NSMakeRange(0, output.length)];
    [output replaceOccurrencesOfString:@"%u" withString:timespan options:0 range:NSMakeRange(0, output.length)];
    [output replaceOccurrencesOfString:@"%c" withString:NSLocalizedString(@"ago", nil) options:0 range:NSMakeRange(0, output.length)];
    
    return output.copy;
}

+ (NSString*)datetoString:(NSDate*)date{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy'T'HH:mm:ss.SSSZ"];
    NSString *result = [df stringFromDate:date];
    
    if([self isEmpty:result])
        result = @"";
    
    return result;
}

+ (NSString*)datetoUTCString:(NSDate*)date{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    NSString *result = [df stringFromDate:date];
    
    if([self isEmpty:result])
        result = @"";
    
    return result;
}

+ (NSDate*)dateFromMilliSeconds:(double)milliSeconds{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:milliSeconds/1000.0];
    return date;
}

+ (NSDate *) toLocalTimeFromGMT:(NSDate *)GMTdate
{
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    return [GMTdate dateByAddingTimeInterval:timeZoneSeconds];
}

+ (NSString*)changeDateString:(NSString*)dateString from:(NSString*)fromFormat to:(NSString*)toFormat{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:fromFormat];
    NSDate *date = [format dateFromString:dateString];
    [format setDateFormat:toFormat];
  
    NSString* finalDateString = [format stringFromDate:date];
    if([self isEmpty:finalDateString])
        finalDateString =  dateString;
    
    return finalDateString;
}

@end
