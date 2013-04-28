//
//  ChannelViewController.h
//  Created by aash on 2013-04-28.


#import <Foundation/Foundation.h>
#import "ListViewController.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController <ListViewControllerDelegate>
{
    RSSChannel *channel;
}

@end
