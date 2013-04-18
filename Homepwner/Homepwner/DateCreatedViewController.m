//  DateCreatedViewController.m
//  Created by aash on 2013-04-15.


#import "DateCreatedViewController.h"
#import "BNRItem.h"

// CLASS CREATED FOR Ch. 11, GOLD CHALLENGE
@implementation DateCreatedViewController

@synthesize changeDateCreatedOnThisItem;

- (id)init {
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        // "Save" button appears in UINavigationBar.
        //  clicking "Save" will update the item's dateCreated property, and pop this view
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:[self navigationController] action:@selector(popViewControllerAnimated:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    return self;
}

// Load dateCreated from our BNRItem-type property, into our "date picker" control
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [dateCreatedField setDate:[changeDateCreatedOnThisItem dateCreated]];
}

// Save the current Date Picker value back to the BNRItem
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear first responder (Q: Is this necessary, when there's no keyboard to dismiss??)
    [[self view] endEditing:YES];
    
    // Save changes back to dateCreated, which is a pointer to that property on the original BNRItem!
    [changeDateCreatedOnThisItem setDateCreated:[dateCreatedField date]];
}


@end
