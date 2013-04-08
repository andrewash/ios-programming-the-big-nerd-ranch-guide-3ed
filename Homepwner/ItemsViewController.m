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

//== Ch. 9, BRONZE CHALLENGE (finished in 50mins) ==
// Tells the UITableView how many sections there are (2)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

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

// == Header ==
- (UIView *)headerView {
    // check to see if it is loaded
    if (!headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)       // only show header view atop the first section (not every section!)
        return [self headerView];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // The height of the header view should be determined from the height of
    //  the view in the XIB file
    if (section == 0)
        return [[self headerView] bounds].size.height;
    else
        return 0;
        // FYI: Prior to iOS 5.0, table views would automatically resize the heights of headers to 0 for sections tableView:viewForHeaderInSection: returned a nil view. In iOS 5.0 and later, you must return the actual height for each section header in this method. (iOS SDK docs)
}

- (IBAction)toggleEditingMode:(id)sender {
    // If we are currently in editing mode
    if ([self isEditing]) {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    }
    else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        [self setEditing:YES animated:YES];
        [sender setHighlighted:YES];
    }
}

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
