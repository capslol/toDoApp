//
//  ViewController.m
//  toDoApp
//
//  Created by Maksim Balov on 19.10.2023.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker.minimumDate = [NSDate date];
    
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged ];
    
    
    [self.buttonSave addTarget:(self) action:@selector(saveTask) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * handleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handeEndEditing)];
    [self.view addGestureRecognizer:handleTap];
    
}

-(void) datePickerValueChanged {
    self.eventDate = self.datePicker.date;
    NSLog(@"selected date %@", self.eventDate);
}

-(void) saveTask {
    NSString * eventInfo = self.textField.text;
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"HH:mm dd:MMMM:yyyy";
    
    NSString * eventDate = [formater stringFromDate:self.eventDate];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           eventInfo,@"eventInfo",
                           eventDate, @"eventDate",  nil];
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    
    notification.userInfo = dict;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
    NSLog(@"saveed");
}
-(void) handeEndEditing {
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    
    return YES;
}

@end
