//  DateCreatedViewController.m
//  Created by aash on 2013-04-15.


#import "DateCreatedViewController.h"
#import "BNRItem.h"

// CLASS CREATED FOR Ch. 11, GOLD CHALLENGE
@implementation DateCreatedViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        // "Save" button appears in UINavigationBar.
        //  clicking "Save" will update the item's dateCreated property, and pop this view
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(finishEditingDateCreated)];
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    return self;
}

- (void)finishEditingDateCreated {
    // TODO: Save any modifications to DateCreated here
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
