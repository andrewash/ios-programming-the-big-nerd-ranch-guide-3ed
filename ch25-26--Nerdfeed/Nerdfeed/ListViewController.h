//
//  ListViewController.h
//  Created by aash on 2013-04-22.


#import <Foundation/Foundation.h>
// a forward declaration; we'll import the header in the .m
@class RSSChannel;
@class WebViewController;

@interface ListViewController : UITableViewController <NSXMLParserDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;
}
@property (nonatomic, strong) WebViewController *webViewController;

- (void)fetchEntries;
@end

// A new protocol names ListViewControllerDelegate
@protocol ListViewControllerDelegate

// Classes that conform to this protocol must implement this method:
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object;

@end
