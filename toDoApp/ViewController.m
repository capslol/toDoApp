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
    
    if(self.isDetail){
        self.textField.text = self.eventInfo;
        self.textField.userInteractionEnabled = NO;
        self.datePicker.userInteractionEnabled = NO;
        self.buttonSave.alpha = 0;
        
        self.datePicker.date = self.eventDate;
    }
    
    self.buttonSave.userInteractionEnabled = NO;
    
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

- (void)saveTask {
    if (!self.eventDate) {
        [self showAlertMessage:@"Для сохранения события измените значение даты на более позднее"];
        return;
    }
    
    NSComparisonResult comparisonResult = [self.eventDate compare:[NSDate date]];
    if (comparisonResult == NSOrderedSame || comparisonResult == NSOrderedAscending) {
        [self showAlertMessage:@"Для сохранения события измените значение даты на более позднее"];
    } else {
        [self setNotification];
    }
}


-(void) setNotification {
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
    if (![self.textField.text isEqualToString:@""]) {
        [self.textField resignFirstResponder];
        self.buttonSave.userInteractionEnabled = YES;
    }
    else {
        [self showAlertMessage:@"Введите значение в текстовое поле"];
    }
    
    return YES;
}


- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
