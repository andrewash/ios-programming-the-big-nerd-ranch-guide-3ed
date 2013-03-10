//
//  TimeViewController.h
//  HypnoTime
//  Created by aash on 2013-03-03.

#import <Foundation/Foundation.h>


@interface TimeViewController : UIViewController
{
    __weak IBOutlet UILabel *timeLabel;
}

- (IBAction)showCurrentTime:(id)sender;
@end
