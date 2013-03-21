//  ItemsViewController.m
//  Created by aash on 2013-03-18.


#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"


@implementation ItemsViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

// ensures all instances of ItemsViewController have "group" styling.
- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}


//== Ch. 9, BRONZE CHALLENGE (finished in 50mins) ==
// Tells the UITableView how many sections there are (2)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[self filterItemsForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    // Set {the text on the cell} with the {description of the item that is at the nth index of items},
    //      where n = {row this cell will appear in on the tableview }
    NSArray *filteredItems = [self filterItemsForSection:[indexPath section]];
    BNRItem *p = [filteredItems objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[p description]];
    return cell;
}

- (NSArray *)filterItemsForSection:(int)section {
    // Filter allItems to have only items for the requested section [elegant solution!]
    NSPredicate *predicate;
    if (section == 0) {         // section 0 === cheap items
        predicate = [NSPredicate predicateWithFormat:@"valueInDollars < 50"];
    }
    else if (section == 1) {    // section 1 === valuable items
        predicate = [NSPredicate predicateWithFormat:@"valueInDollars >= 50"];
    }
    else {
        NSLog(@"Error: Expected no more than two sections");
    }
    
    NSArray *allItems      = [[BNRItemStore sharedStore] allItems];
    NSArray *filteredItems = [allItems filteredArrayUsingPredicate:predicate];
    return filteredItems;
}
//== end of BRONZE CHALLENGE ==

@end
