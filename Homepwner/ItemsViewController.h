//  ItemsViewController.h
//  Created by aash on 2013-03-18.


#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}

- (UIView *)headerView;
- (IBAction)addNewItem:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;

// Helper methods
+ (NSArray *)filterItemsForSection:(int)section;
- (bool)isIndexPathInDataStore:(NSIndexPath *)indexPath;
@end
