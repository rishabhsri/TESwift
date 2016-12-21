//
//  NSDate+Utilities.h
//  SignUpMod
//
//  Created by Nipur Garg on 7/29/15.
//  Copyright (c) 2015 VGroup Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)

+ (NSString*)getTimeDiffSinceDate:(NSDate*)date;

+ (NSString*)datetoString:(NSDate*)date;

+ (NSDate*)dateFromMilliSeconds:(double)milliSeconds;

+ (NSDate *) toLocalTimeFromGMT:(NSDate *)GMTdate;

+ (NSString*)datetoUTCString:(NSDate*)date;

+ (NSString*)changeDateString:(NSString*)dateString from:(NSString*)fromFormat to:(NSString*)toFormat;

@end
