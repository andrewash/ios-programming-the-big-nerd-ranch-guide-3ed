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

//----------------------------------------------------------------------------------------------------------------------------------------------
// Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
//   for the next two properties, here's an example (from the RSS Feed XML):
//      <guid isPermaLink="false">
//        http://forums.bignerdranch.com/viewtopic.php?f=400&t=6278&p=17192#p17192
//      </guid>
//   threadID appears to be unique across all forums; this makes our job easier
@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger threadID;

- (void)parseIDsFromCurrentStringURL;
//================================================================================================================================================

@end
