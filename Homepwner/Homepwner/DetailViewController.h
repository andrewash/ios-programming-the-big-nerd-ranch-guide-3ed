//  DetailViewController.h
//  Created by aash on 2013-04-14.


#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *changeDateButton;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *removeImageButton;  // Ch. 12, SILVER CHALLENGE
    
    UIPopoverController *imagePickerPopover;
}
@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, assign, getter=isNewItem) BOOL newItem;
@property (nonatomic, copy) void (^dismissBlock)(void);  // a property named dismissBlock that points to a block
                                                         // like a C-function, it has a return value and list of arguments

- (id)initForNewItem:(BOOL)isNew;
- (void)showDoneButtonInToolbar;
- (IBAction)changeDateCreated:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)removeImage:(id)sender;  // Ch. 12, SILVER CHALLENGE
@end