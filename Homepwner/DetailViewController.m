//  DetailViewController.m
//  Created by aash on 2013-04-14.


#import "DetailViewController.h"
#import "BNRItem.h"

// fix for iPhone 5+
// source http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


@implementation DetailViewController

@synthesize item;

// Ch. 11, SILVER CHALLENGE
- (id)init {
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        [self showDoneButtonInToolbar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DetailViewController loaded its view.");
    
    // FYI - background image obtained for non-commercial purposes
    // source: http://3.bp.blogspot.com/-wVbOcUcUP58/UFHQBu3BneI/AAAAAAAAKt4/HG1mY0qcpPM/s1600/artistic-abstract-95.jpg
    UIImageView *backgroundImage = [[UIImageView alloc]
                                    initWithImage:[UIImage imageNamed:iPhone568ImageNamed(@"wallpaper.jpg")]];

    // HOWTO: Set an image background (http://stackoverflow.com/a/2393920/1660322)
    [[self view] addSubview:backgroundImage];
    [[self view] sendSubviewToBack:backgroundImage];
}

// Show properties of (BNRItem *)item
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

// Save changes to the item
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (void)setItem:(BNRItem *)i {
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

// Ch. 11, SILVER CHALLENGE
// Users see "Save" in the navbar while a field is being edited (instead of "Done")
//   "target-action" pattern => tapping "Save" will dismiss the keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing event for field with value %@", [textField text]);
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:textField action:@selector(resignFirstResponder)];
    
    // Set this bar button item as the right item int he navigationItem
    [[self navigationItem] setRightBarButtonItem:bbi];
}

// Ch. 11, SILVER CHALLENGE
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing event for field with value %@", [textField text]);
    [self showDoneButtonInToolbar];
}

// Ch. 11, SILVER CHALLENGE
- (void)showDoneButtonInToolbar {
    // Users see "Done" button in navbar, whenever a field isn't being edited. Tapping this button saves changes & pops DetailViewController from the NavigationController stack
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:[self navigationController] action:@selector(popViewControllerAnimated:)];
    
    // Set this bar button item as the right item int he navigationItem
    [[self navigationItem] setRightBarButtonItem:bbi];
}

// When user taps the "return" key, while editing any textField, dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// Ch. 11, GOLD CHALLENGE
- (IBAction)changeDateCreated:(id)sender {
    
}
@end
