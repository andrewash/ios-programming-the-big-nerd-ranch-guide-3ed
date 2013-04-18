//  DetailViewController.h
//  Created by aash on 2013-04-14.


#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *changeDateButton;
}
@property (nonatomic, strong) BNRItem *item;

- (void)showDoneButtonInToolbar;
- (IBAction)changeDateCreated:(id)sender;
@end