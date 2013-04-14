//  ItemsViewController.h
//  Created by aash on 2013-03-18.


#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}

- (UIView *)headerView;
- (IBAction)addNewItem:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;

// Helper methods
+ (NSIndexPath *)indexPathForBNRItem:(BNRItem *)item;
+ (BNRItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
+ (NSArray *)filterItemsForSection:(int)section;
- (bool)isIndexPathInDataStore:(NSIndexPath *)indexPath;
@end
