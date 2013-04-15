//  ItemsViewController.m
//  Created by aash on 2013-03-18.


#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

//==Ch. 9, GOLD challenge
// fix for iPhone 5+
// source http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])

@implementation ItemsViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Homepwner"];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item int he navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

// ensures all instances of ItemsViewController have "group" styling.
- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

//== Ch. 9, GOLD challenge
- (void)viewDidLoad {
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    NSLog(@"ItemsViewController loaded its view.");

    // FYI - background image obtained for non-commercial purposes
        // source: http://3.bp.blogspot.com/-wVbOcUcUP58/UFHQBu3BneI/AAAAAAAAKt4/HG1mY0qcpPM/s1600/artistic-abstract-95.jpg
    UIImageView *backgroundImage = [[UIImageView alloc]
                                    initWithImage:[UIImage imageNamed:iPhone568ImageNamed(@"wallpaper.jpg")]];
    [[[self tableView] backgroundView] addSubview:backgroundImage];
}

// When returning from the Detail View, reload the table, in case one of the items has changed
    // note: sounds inefficient, but that's how the book does it.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

//== Ch. 9, BRONZE CHALLENGE (finished in 50mins) ==
// Tells the UITableView how many sections there are (2)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// GLOBAL STRUCTURE & FORMATTING
// -----------------------------
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    int rows = [[ItemsViewController filterItemsForSection:section] count];
    if (section == 1)   // Ch. 9, SILVER challenge ("last row has the text 'No more items!'")
        return rows+1;
    else
        return rows;
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
    NSArray *filteredItems = [ItemsViewController filterItemsForSection:[indexPath section]];
    
    // Ch. 9, SILVER challenge
    if ([self isIndexPathInDataStore:indexPath]) {
        BNRItem *p = [filteredItems objectAtIndex:[indexPath row]];
        // ---------------------
        // Ch. 9, GOLD challenge
        //   we change font size by updating the cell's UILabel's UIFont property
        UIFont *defaultFont = [[cell textLabel] font];
        [[cell textLabel] setFont:[defaultFont fontWithSize:20]];
        // ---------------------
        [[cell textLabel] setText:[p description]];
    }
    else {
        [[cell textLabel] setText:@"No more items!"];
    }
    return cell;
}

// Ch. 9, GOLD challenge
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isIndexPathInDataStore:indexPath])
        return 60;
    else
        return 44;
}

// <MANUAL-STYLE-HEADER>    >>> We're using UINavigationBar and UINavigationItem instead
//                              FYI - I'm retaining this code (commented out), so I can easily remember that it's there in source code repo,
//                                    in case I want to use some of the same techniques later on
//- (UIView *)headerView {
//    // check to see if it is loaded
//    if (!headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return headerView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0)       // only show header view atop the first section (not every section!)
//        return [self headerView];
//    else
//        return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    // The height of the header view should be determined from the height of
//    //  the view in the XIB file
//    if (section == 0)
//        return [[self headerView] bounds].size.height;
//    else
//        return 0;
//        // FYI: Prior to iOS 5.0, table views would automatically resize the heights of headers to 0 for sections tableView:viewForHeaderInSection: returned a nil view. In iOS 5.0 and later, you must return the actual height for each section header in this method. (iOS SDK docs)
//}
//
//- (IBAction)toggleEditingMode:(id)sender {
//    // If we are currently in editing mode
//    if ([self isEditing]) {
//        // Change text of button to inform user of state
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        // Turn off editing mode
//        [self setEditing:NO animated:YES];
//    }
//    else {
//        // Change text of button to inform user of state
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        // Enter editing mode
//        [self setEditing:YES animated:YES];
//        [sender setHighlighted:YES];
//    }
//}
// </MANUAL-STYLE-HEADER>


// NEW ITEM METHODS
// ----------------
- (IBAction)addNewItem:(id)sender {
    // Add an item to the BNRItemStore (which creates a new random item)
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
//    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Figure out where that item is in the array

    NSIndexPath *ip = [ItemsViewController indexPathForBNRItem:newItem];
    // Insert this new row into the table.
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationTop];
}

// DELETE METHODS
// ------------------
// Ch. 10, Bronze Challenge: "Renaming the Delete button"
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        BNRItem *p = [ItemsViewController itemAtIndexPath:indexPath];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}


// REORDERING METHODS
// ------------------

// Update the data source to respond to a move (the move has already happened in the view
//   FYI: BNRItemStore stores items in the order they were created.
//        The book's solution of using [indexPath row] to reference the item being moved won't work for us
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                                                  toIndexPath:(NSIndexPath *)destinationIndexPath {

    if ([self isIndexPathInDataStore:sourceIndexPath] == NO)
    {
        // moving a pseudo-item doesn't affect the data store at all
        return;
    }
    else
    {
        if ([sourceIndexPath section] != [destinationIndexPath section])
            NSLog(@"Error: moving an item from one section, to another section, is not supported.");
        
        BNRItem *itemAtSource = [ItemsViewController itemAtIndexPath:sourceIndexPath];
        BNRItem *itemCurrentlyAtDestination = [ItemsViewController itemAtIndexPath:destinationIndexPath];
        
        int allItemsSourceIndex = [[[BNRItemStore sharedStore] allItems] indexOfObjectIdenticalTo:itemAtSource];
        int allItemsDestinationIndex = [[[BNRItemStore sharedStore] allItems] indexOfObjectIdenticalTo:itemCurrentlyAtDestination];
        
        [[BNRItemStore sharedStore] moveItemAtIndex:allItemsSourceIndex
                                            toIndex:allItemsDestinationIndex];
    }
}

// Ch. 10, Silver Challenge: Preventing Reordering
// restricts rows to relocation within their own section, and prevents moves to any other section
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                                                                         toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    int proposedDestinationRow;
    int proposedDestinationSection = [sourceIndexPath section];

    // reject moving any pseudo-item (ex. the "No more items" row)
    if ([self isIndexPathInDataStore:sourceIndexPath] == NO) {
        return sourceIndexPath;
    }
        
    // reject moving an item to any section beyond its own
    //   propose this instead: the last/first row of the source item's section
    if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
        if ([sourceIndexPath section] == 0)
        {
            proposedDestinationRow = [self tableView:tableView numberOfRowsInSection:proposedDestinationSection] - 1;  // row's are 0-based
        }
        else if ([sourceIndexPath section] == 1)
        {
            proposedDestinationRow = 0;
        }
        else
        {
            proposedDestinationRow = [sourceIndexPath row];
            NSLog(@"Error: didn't expect more than two sections. Was asked to move an item from section %d", proposedDestinationSection);
        }
        
        return [NSIndexPath indexPathForRow:proposedDestinationRow inSection:proposedDestinationSection];
    }
    
    // Ch. 10, Gold Challenge: Really Preventing Reordering
    // reject moving anything to the "No more items" row
    if ([self isIndexPathInDataStore:proposedDestinationIndexPath] == NO) {
        proposedDestinationRow = [proposedDestinationIndexPath row] - 1;
        // check if this item was being moved between sections
        if ([sourceIndexPath section] != [proposedDestinationIndexPath section])
            proposedDestinationSection = [sourceIndexPath section];
        else
            proposedDestinationSection = [proposedDestinationIndexPath section];
        return [NSIndexPath indexPathForRow:proposedDestinationRow inSection:proposedDestinationSection];
    }

    
    // OTHERWISE, if we've passed every other check...
    // return the proposed destination as-is, b/c it's approved
    return proposedDestinationIndexPath;
}


// DETAIL VIEW METHODS
// -------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [[DetailViewController alloc] init];

    BNRItem *selectedItem = [ItemsViewController itemAtIndexPath:indexPath];
    
    // Give detail view controller a pointer to the item object rep. by this row
    [detailViewController setItem:selectedItem];

    // Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController animated:YES];
}


//========================
//==== HELPER METHODS ====
//------------------------
// Ch. 9, GOLD challenge -- refactored code from silver challenge into this helper method
- (bool)isIndexPathInDataStore:(NSIndexPath *)indexPath {
    int rowToDisplay = [indexPath row] + 1;  // "+ 1" because indexPath is 0-based, but [NSArray count] is 1-based
    int lastRowInDataStore = [[ItemsViewController filterItemsForSection:[indexPath section]] count];
    if (rowToDisplay <= lastRowInDataStore)
        return true;
    else
        return false;
}

+ (NSIndexPath *)indexPathForBNRItem:(BNRItem *)item {
    int rowIndex = NSNotFound;
    int secIndex = NSNotFound;

    // look for this item in first section
    rowIndex = [[ItemsViewController filterItemsForSection:0] indexOfObject:item];
    if (rowIndex != NSNotFound) {
        secIndex = 0;
    }
    else {
        // look for item in the second section, if not found in first section
        rowIndex = [[ItemsViewController filterItemsForSection:1] indexOfObject:item];
        if (rowIndex != NSNotFound) {
            secIndex = 1;
        }
        else {
            NSLog(@"Error: requested item not found in BNRItemStore");
        }
    }
    return [NSIndexPath indexPathForRow:rowIndex inSection:secIndex];
}

+ (BNRItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionItems = [ItemsViewController filterItemsForSection:[indexPath section]];
    return [sectionItems objectAtIndex:[indexPath row]];
}


// I learned about NSPredicate from iOS Docs &&  http://goo.gl/k626r
+ (NSArray *)filterItemsForSection:(int)section {
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
