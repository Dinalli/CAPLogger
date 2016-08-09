//
//  CAPLogger.m
//  CAPLogger
//
//  Created by Andrew Donnelly on 05/08/2016.
//  Copyright © 2016 jlr. All rights reserved.
//

#import "CAPLogger.h"

@interface CAPLogger()
{
    NSDateFormatter *dateFormatter;
}
@end

@implementation CAPLogger

NSString *const kNotificationUpdateEventDisplay = @"kNotificationUpdateEventDisplay";
// Public calls

- (id)init
{
    if (self = [super init])
    {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/London"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    return self;
}

// log event to file
-(void)logEventWithEventType:(CAPEventType)eventType withIdentifier:(NSString *)eventId withDate:(NSDate *)eventTime vehicleVin:(NSString *)vin andData:(NSDictionary *)eventData;
{
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSString *eventDataString = [NSString stringWithFormat:@"%@", eventData];
    eventDataString = [eventDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *writeString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@\r\n",[dateFormatter stringFromDate:eventTime], vin, logEventTypeString(eventType),eventId,eventDataString];
    
    // check if file exists, if not create it and write to it.
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath:[self logFile]];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self addDisplayEvent:@{@"eventId":eventId,@"eventType":logEventTypeString(eventType),@"eventTimestamp":[dateFormatter stringFromDate:eventTime], @"vin":vin ,@"eventData":eventDataString}];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self houseKeepFiles];
    });
}

#pragma mark register event
-(void)addDisplayEvent:(NSDictionary *)eventInfo
{
    if (_displayEvents == nil) { _displayEvents = [[NSMutableArray alloc] init]; }
    [_displayEvents insertObject:eventInfo atIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateEventDisplay object:nil userInfo:@{@"eventInfo":eventInfo}];
}

// Private calls
// Create log file if one doesnt exist for that day
-(NSString *)logFile
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    
    NSDate *today = [NSDate new];
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:today];
    [dateFormatter setDateFormat:@"MMM"];
    NSString *month = [dateFormatter stringFromDate:today];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:today];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSString *fileName = [NSString stringWithFormat:@"/logfile_%@%@%@.csv",day, month, year ];
    NSString *fileDirectory = [documentPath stringByAppendingString:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory])
    {
        // create it.
        [[NSFileManager defaultManager] createFileAtPath:fileDirectory contents:nil attributes:nil];
    }
    
    return fileDirectory;
}

// House keep - remove files over 7 days old
-(void)houseKeepFiles
{
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                    value:-7
                                                                   toDate:[NSDate date]
                                                                  options:0];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:sevenDaysAgo];
    [dateFormatter setDateFormat:@"MMM"];
    NSString *month = [dateFormatter stringFromDate:sevenDaysAgo];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:sevenDaysAgo];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    
    NSString *fileName = [NSString stringWithFormat:@"/logfile_%@%@%@.csv",day, month, year ];
    NSString *fileDirectory = [documentPath stringByAppendingString:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileDirectory])
    {
        // remove it.
        [[NSFileManager defaultManager] removeItemAtPath:fileDirectory error:nil];
    }
}

+ (CAPLogger *)sharedCAPLogger
{
    __strong static CAPLogger *sharedLogger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [[self alloc] init];
    });
    return sharedLogger;
}
@end
