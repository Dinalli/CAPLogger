//
//  CAPLogger.h
//  CAPLogger
//
//  Created by Andrew Donnelly on 09/08/2016.
//  Copyright © 2016 jlr. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for CAPLogger.
FOUNDATION_EXPORT double CAPLoggerVersionNumber;

//! Project version string for CAPLogger.
FOUNDATION_EXPORT const unsigned char CAPLoggerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CAPLogger/PublicHeader.h>

@interface CAPLogger : NSObject

typedef enum {
    AllEvents,
    StatusChangeEvents,
    BlubEvents,
    TsdpEvents,
    NotificationEvents
} CAPEventLogLevel;

typedef enum {
    StatusChangeEvent,
    CLIENTEvent,
    TSDPEvent,
    NotificationEvent
} CAPEventType;

extern NSString *const kNotificationUpdateEventDisplay;

#define logEventTypeString(enum) [@[@"StatusChangeEvent",@"CLIENTEvent",@"TSDPEvent" @"NotificationEvent"] objectAtIndex:enum]

@property (nonatomic) CAPEventLogLevel logLevel;
@property (nonatomic) NSMutableArray *displayEvents;

-(void)logEventWithEventType:(CAPEventType)eventType withIdentifier:(NSString *)eventId withDate:(NSDate *)eventTime vehicleVin:(NSString *)vin andData:(NSDictionary *)eventData;
-(void)logEventWithCustomKey:(NSString*)customKey EventDate:(NSDate *)eventTime Data:(NSDictionary *)eventData withVisualNotification:(BOOL)showNotification;

+ (CAPLogger *)sharedCAPLogger;


@end
