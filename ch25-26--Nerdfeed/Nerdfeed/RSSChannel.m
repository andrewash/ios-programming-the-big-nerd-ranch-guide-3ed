//
//  RSSChannel.m
//  Created by aash on 2013-04-25.


#import "RSSChannel.h"
#import "RSSItem.h"

//----------------------------------------------------------------------------------------------------------------------------------------------
// Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
// FYI: Extensive changes were made to this file for this challenge, especially:
//   - new data structure, theadsOfItems, an NSMutableArray of NSMutableArrays; each "thread" is modeled as a NSMutableArray of RSSItems
//   - keeping track of the currentItem, not just the currentString
//   - an important new method: addItemToThreadOrCreateNewThreadFor:item
//   - trimItemTitles enumerates each thread, and each item within each thread (a simple change)
//   - threadsOfItems are updated in "parser:didEndElement", not "parser:didStartElement", b/c the item's contents weren't populated until then

@implementation RSSChannel
@synthesize threadsOfItems, title, infoString, parentParserDelegate;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Create the container for the RSSItems this channel has;
        // we'll create the RSSItem class shortly.
        threadsOfItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    WSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    }
    else if ([elementName isEqual:@"description"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setInfoString:currentString];
    }
    else if ([elementName isEqual:@"item"])
    {
        // When we find an item, create an instance of RSSItem
        currentItem = [[RSSItem alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [currentItem setParentParserDelegate:self];
        
        // Hand-off parsing duties to the RSSItem
        [parser setDelegate:currentItem];
    }
}

//----------------------------------------------------------------------------------------------------------------------------------------------
// Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
//   assumptions: XML is sorted in reverse chronological order by "date posted" (most recent first) (source: BNR guide, pg. 441: "the server will return XML data that contains *the last* 20 posts")
- (void)addItemToThreadOrCreateNewThreadFor:(RSSItem *)item
{
    NSMutableArray *matchingThread;
    
    for (NSMutableArray *thread in threadsOfItems) {
        RSSItem *mostRecentItemInThread = [thread objectAtIndex:0];
        if([mostRecentItemInThread threadID] == [item threadID])  // found an existing thread for the item we're trying to add
        {
            [thread addObject:item];
            matchingThread = thread;
            WSLog(@"Thread matched for item with postID=%d", [item postID]);
            return;
        }
    }

    if (!matchingThread) // this item is for a thread we've never seen before
    {
        matchingThread = [[NSMutableArray alloc] initWithObjects:item, nil];
        [threadsOfItems addObject:matchingThread];
        WSLog(@"Thread created with threadID=%d, based upon postID=%d", [[matchingThread objectAtIndex:0] threadID], [item postID]);
    }
}
//================================================================================================================================================

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)str
{
    [currentString appendString:str];
}

// Return control of the parser to the ListViewController
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    // If we were in an element that we were collecting the string for,
    // this appropriately releases our hold on it and the permanent ivar keeps
    // ownership of it. If we weren't parsing such an element, currentString is nil already.
    currentString = nil;
    
    //----------------------------------------------------------------------------------------------------------------------------------------------
    // Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
    if ([elementName isEqual:@"item"])  // If the element that ended was an item, add it to the appropriate thread, or create a new thread for it, if it doesn't exist
        [self addItemToThreadOrCreateNewThreadFor:currentItem];
    //================================================================================================================================================

    // If the element that ended was the channel, give up control to who gave us control in the first place
    if ([elementName isEqual:@"channel"])
    {
        [parser setDelegate:parentParserDelegate];
        [self trimItemTitles];
    }
}

- (void)trimItemTitles
{
    //-----------------------------------------------------------------------
    // Final Exam, Q2 (Ch. 26, Silver Challenge: Processing the Reply)
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@".* :: (Re:)?(.*) :: .*" options:0 error:nil];
    //=======================================================================

    // Loop through every title of the items in channel
    for (NSMutableArray *thread in threadsOfItems)
    {
        for (RSSItem *i in thread) {
            NSString *itemTitle = [i title];
            
            // Find matches in the title string. The range argument specifies how much of the
            // title to search; in this case, all of it.
            NSArray *matches = [regex matchesInString:itemTitle options:0 range:NSMakeRange(0, [itemTitle length])];
            
            // If there was a match
            if ([matches count] > 0)
            {
                // Print the location of the match in the string and the string itself
                NSTextCheckingResult *result = [matches objectAtIndex:0];
                WSLog(@"Match at {%d, %d} for %@!", [result range].location, [result range].length, itemTitle);
                
                // One capture group, so two ranges, let's verify
                if ([result numberOfRanges] == 2)
                {
                    // Pull out the second range, which will be the capture group
                    NSRange r = [result rangeAtIndex:1];
                    
                    // Set the title of the item to the string within the capture group
                    [i setTitle:[itemTitle substringWithRange:r]];
                }
            }
        }
    }
}


@end
