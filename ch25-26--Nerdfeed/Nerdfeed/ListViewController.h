//
//  ListViewController.h
//  Created by aash on 2013-04-22.


#import <Foundation/Foundation.h>
// a forward declaration; we'll import the header in the .m
@class RSSChannel;

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;
}
- (void)fetchEntries;

@end
