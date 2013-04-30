//
//  RSSChannel.h
//  Created by aash on 2013-04-25.


#import <Foundation/Foundation.h>
@class RSSItem;

@interface RSSChannel : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
    RSSItem *currentItem;
}
@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, readonly, strong) NSMutableArray *threadsOfItems;

- (void)trimItemTitles;
- (void)addItemToThreadOrCreateNewThreadFor:(RSSItem *)item;
@end
