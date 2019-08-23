#include <EventKit/EventKit.h>
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

BOOL createReminder(EKEventStore *store, NSString *title, NSDate *date) {
    EKReminder *reminder = [EKReminder reminderWithEventStore:store];
    [reminder setTitle:title];
    if (date) {
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitHour |
                                                         NSCalendarUnitMinute)
                                               fromDate:date];
        [reminder setDueDateComponents:comps];
    }
    EKCalendar *defaultReminderList = [store defaultCalendarForNewReminders];
    [reminder setCalendar:defaultReminderList];
    NSError *error = nil;
    BOOL success = [store saveReminder:reminder
                                commit:YES
                                 error:&error];
    if (!success) {
        NSLog(@"Error saving reminder: %@", [error localizedDescription]);
    }
    return success;
}

@interface AppDelegate ()
@property (nonnull, strong) EKEventStore *eventStore;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                    completion:^(BOOL granted, NSError *error) {
                                        if (granted) {
                                            NSLog(@"Permission granted to access reminders!");
                                        } else {
                                            NSLog(@"No permission for accessing reminders: %@", error);
                                            // FIXME: report back to flutter
                                        }
                                    }];
    FlutterViewController* controller = (FlutterViewController *)self.window.rootViewController;
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"com.factisresearch/reminders"
                                            binaryMessenger:controller];
    __weak AppDelegate *weakSelf = self;
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // Note: this method is invoked on the UI thread.
        AppDelegate *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([@"createReminder" isEqualToString:call.method]) {
            NSArray *args = call.arguments;
            NSString *title;
            NSDate *date;
            if (args.count == 1) {
                title = [args objectAtIndex:0];
            } else if (args.count == 2) {
                title = [args objectAtIndex:0];
                NSNumber *dateNum = [args objectAtIndex:1];
                date = [[NSDate alloc] initWithTimeIntervalSince1970:[dateNum integerValue]];
                if (date == nil) {
                    result([FlutterError errorWithCode:@"ARGUMENT_ERROR"
                                               message:@"Cannot parse date"
                                               details:nil]);
                    return;
                }
            } else {
                result([FlutterError errorWithCode:@"ARGUMENT_ERROR"
                                           message:@"Invalid number of arguments"
                                           details:nil]);
                return;
            }
            BOOL ok = createReminder(strongSelf.eventStore, title, date);
            if (!ok) {
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                           message:@"Cannot create reminder"
                                           details:nil]);
            } else {
                result(@(ok));
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

    [GeneratedPluginRegistrant registerWithRegistry:self];

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
