//
//  RSSItem.h
//  Created by aash on 2013-04-25.


#import <Foundation/Foundation.h>

@interface RSSItem : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
}
@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;

@end
