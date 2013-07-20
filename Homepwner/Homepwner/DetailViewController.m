//  DetailViewController.m
//  Created by aash on 2013-04-14.


#import "DetailViewController.h"
#import "BNRItem.h"
#import "DateCreatedViewController.h"
#import "BNRImageStore.h"


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
//   Ch. 11, Gold Challenge - this should automatically refresh the view, after DateCreated has changed
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
    DateCreatedViewController *dateCreatedViewController = [[DateCreatedViewController alloc] init];

    // pass pointer to the item being edited (and *not* the NSDate itself, which won't work)
    [dateCreatedViewController setChangeDateCreatedOnThisItem:item];

    [[self navigationController] pushViewController:dateCreatedViewController animated:YES];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This line of code will generate a warning right now, ignore it
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen (modally)
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
        // FYI - "CF" prefix === Core Foundation, a collection of C "classes" & functions
        //       "Ref" suffix === it's a pointer
    
    // Create a string from the unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    // Store image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:[item imageKey]];
    
    // Core Foundation objects must be CFRelease'd, or a memory leak will result
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    // Put that image onto the screen in our image view
    [imageView setImage:image];
    
    // Take image picker off the screen -
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
