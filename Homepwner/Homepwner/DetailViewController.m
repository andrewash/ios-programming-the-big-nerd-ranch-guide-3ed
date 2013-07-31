//  DetailViewController.m
//  Created by aash on 2013-04-14.


#import "DetailViewController.h"
#import "BNRItem.h"
#import "DateCreatedViewController.h"
#import "BNRImageStore.h"
#import "CameraOverlayView.h"


// aash: Why is this needed?
//// fix for iPhone 5+
//// source http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build (??)
//#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
//#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
//#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


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

    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:clr];
    
    // background image must be square, i.e. iPad 2x is 2048x2048, not ~1536x2048)
    UIImageView *backgroundImage = [[UIImageView alloc]
                                    initWithImage:[UIImage imageNamed:@"background"]];

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
    
    NSString *imageKey = [item imageKey];
    if (imageKey) {
        // Get image from the image store, based on the key
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put the screen in imageView
        [imageView setImage:imageToDisplay];

        // Ch. 12, SILVER CHALLENGE
        // When this item has an image, users see a button that allows removing it
        [removeImageButton setHidden:NO];
    }
    else {
        // Clear the imageView
        [imageView setImage:nil];
        
        // Ch. 12, SILVER CHALLENGE
        // When this item doesn't have an image, hide the "remove image" button
        [removeImageButton setHidden:YES];
    }
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

// FYI - orientations are controlled Info.plist > Deployment settings
//- (NSUInteger)supportedInterfaceOrientations {
//}


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
    if ([imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setAllowsEditing:YES];  // Ch. 12, BRONZE CHALLENGE, user can scale & crop an image before they "use" it in this app

    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This line of code will generate a warning right now, ignore it
    [imagePicker setDelegate:self];
    
    //------------------------------------------------------------------------------------
    // Ch. 12, Gold Challenge - "show a crosshair in the middle of the capture area"
    // iPhone-only feature
    //   b/c CameraOverlayView may not be compatible with UIPopoverController
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // 1. Determine the frame within which the crosshair will be drawn
        CGRect screenRect = [[[self view] window] bounds];
        CGPoint centre;
        centre.x = screenRect.origin.x + screenRect.size.width / 2.0;
        centre.y = screenRect.origin.y + screenRect.size.height / 2.0;
        CGSize size;
        size.width = screenRect.size.width * 0.2;
        size.height = screenRect.size.height * 0.2;
        CGRect overlayRect = CGRectMake(centre.x - size.width/2, centre.y - size.height/2, size.width, size.height);
        
        // 2. Create the overlay's UIView within that frame
        UIView *overlayView = [[CameraOverlayView alloc] initWithFrame:overlayRect];
        
        // 3. Tell the image picker to show an overlay view
        [imagePicker setCameraOverlayView:overlayView];
    }
    //====================================================================================
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // Create a new popover controller that will display the imagepicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller;
        //  sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;  // to destroy the popover
                               // we create a new one each time the "camera" bar button item is tapped
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *oldImageKey = [item imageKey];
    // Did the item already have an image?
    if (oldImageKey) {
        // Clear out the old image, from the image store
        [[BNRImageStore sharedStore] deleteImageForKey:oldImageKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];  // Ch. 12, BRONZE CHALLENGE, use the edited image, instead of the original one
        // SDK: "A dictionary containing the original image and the edited image."
    
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
    
    // Ch. 12, SILVER CHALLENGE
    // When this item has an image, users can remove it
    [removeImageButton setHidden:NO];
    
    // Take image picker off the screen -
    // you must call this dismiss method
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // @iPhone: the image picker is presented modally. Dismiss it.
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // @iPad: image picker is in the popover. Dismiss the popover.
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

// Ch. 12, SILVER CHALLENGE
- (IBAction)removeImage:(id)sender {
    NSString *imageKey = [item imageKey];
    if (imageKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:imageKey];
        [item setImageKey:nil];
        // remember to update the view (so image is cleared, and "remove image" button hidden)
        [self viewWillAppear:NO];
    } else {
        NSLog(@"ASSERT FAILED - \'remove image\' button was tapped while no image is present for this item");
    }
}
@end
