//  ItemsViewController.h
//  Created by aash on 2013-03-18.


#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController
{
    
}
// Helper methods
+ (NSArray *)filterItemsForSection:(int)section;
- (bool)isIndexPathInDataStore:(NSIndexPath *)indexPath;
@end
