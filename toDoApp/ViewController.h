//
//  ViewController.h
//  toDoApp
//
//  Created by Maksim Balov on 19.10.2023.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) NSString *eventInfo;
@property (nonatomic, assign) BOOL isDetail;
@end

