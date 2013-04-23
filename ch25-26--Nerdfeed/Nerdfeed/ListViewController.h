//
//  ListViewController.h
//  Created by aash on 2013-04-22.


#import <Foundation/Foundation.h>

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
}
- (void)fetchEntries;

@end
