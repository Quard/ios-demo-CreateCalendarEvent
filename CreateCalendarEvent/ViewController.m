//
//  ViewController.m
//  CreateCalendarEvent
//
//  Created by Vadym Zakovinko on 1/3/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapAddCalendarEvent:(id)sender {
    if (!self.titleText.text) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Ender title"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // request access to calendar
    // message to user will be shown only one time
    [[EKEventStore alloc] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [self addCalendarEvent];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Access to calendar forbidden"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)addCalendarEvent {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKCalendar *calendar = nil;
    NSString *identifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"calendar_identifier"]; // will be nil if not exists
    
    if (identifier) {
        calendar = [eventStore calendarWithIdentifier:identifier]; // get existing calendar
    }
    
    // checks if exists because user can remove our calendar
    if (!calendar) {
        calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
        calendar.title = @"CreateCalendarEvent APP";
        
        // set source to local (we use local calendar that not be synced)
        for (EKSource *source in eventStore.sources) {
            if (source.sourceType == EKSourceTypeLocal) {
                calendar.source = source;
                break;
            }
        }
        
        NSError *error;
        [eventStore saveCalendar:calendar commit:YES error:&error];
        if (error) {
            NSLog(@"create calendar error: %@", [error description]);
            calendar = nil;
        } else {
            [[NSUserDefaults standardUserDefaults] setValue:calendar.calendarIdentifier
                                                     forKey:@"calendar_identifier"];
        }
    }
    
    if (calendar) {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.calendar = calendar;
        event.title = self.titleText.text;
        event.notes = self.noteText.text;
        event.startDate = self.datePicker.date;
        event.endDate = [self.datePicker.date dateByAddingTimeInterval:3600 * 2]; // +2 hours
        
        // adding alert on date
        EKAlarm *alarm = [[EKAlarm alloc] init];
        [alarm setAbsoluteDate:self.datePicker.date];
        [event addAlarm:alarm];
        
        NSError *error = nil;
        [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (error) {
            NSLog(@"event save error: %@", [error description]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"event saved"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
