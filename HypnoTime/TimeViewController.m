//
//  TimeViewController.m
//  HypnoTime
//  Created by aash on 2013-03-03.


#import "TimeViewController.h"

@implementation TimeViewController

- (IBAction)showCurrentTime:(id)sender
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    [timeLabel setText:[formatter stringFromDate:now]];
}
@end
