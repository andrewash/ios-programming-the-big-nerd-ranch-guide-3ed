//  DetailViewController.h
//  Created by aash on 2013-04-14.


#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
}

@end
