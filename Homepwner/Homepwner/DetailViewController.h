//  DetailViewController.h
//  Created by aash on 2013-04-14.


#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *changeDateButton;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *removeImageButton;  // Ch. 12, SILVER CHALLENGE
}
@property (nonatomic, strong) BNRItem *item;

- (void)showDoneButtonInToolbar;
- (IBAction)changeDateCreated:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)removeImage:(id)sender;  // Ch. 12, SILVER CHALLENGE
@end