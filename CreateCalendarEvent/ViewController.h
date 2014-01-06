//
//  ViewController.h
//  CreateCalendarEvent
//
//  Created by Vadym Zakovinko on 1/3/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *noteText;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)tapAddCalendarEvent:(id)sender;

- (void)addCalendarEvent;

@end
