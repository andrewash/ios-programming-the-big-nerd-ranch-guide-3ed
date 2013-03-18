//  ItemsViewController.m
//  Created by aash on 2013-03-18.


#import "ItemsViewController.h"

@implementation ItemsViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

// ensures all instances of ItemsViewController have "group" styling.
- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}
@end
