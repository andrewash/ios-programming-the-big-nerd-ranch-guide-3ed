//
//  ListViewController.h
//  Created by aash on 2013-04-22.


#import <Foundation/Foundation.h>
// a forward declaration; we'll import the header in the .m
@class RSSChannel;
@class WebViewController;

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;
}
@property (nonatomic, strong) WebViewController *webViewController;

- (void)fetchEntries;
@end
