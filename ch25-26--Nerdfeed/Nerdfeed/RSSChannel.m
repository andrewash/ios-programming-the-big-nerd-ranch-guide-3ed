//
//  RSSChannel.m
//  Created by aash on 2013-04-25.


#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel
@synthesize items, title, infoString, parentParserDelegate;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Create the container for the RSSItems this channel has;
        // we'll create the RSSItem class shortly.
        items = [[NSMutableArray alloc] init];
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
        RSSItem *entry = [[RSSItem alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [entry setParentParserDelegate:self];
        
        // Hand-off parsing duties to the RSSItem
        [parser setDelegate:entry];
        
        // Add the item to our array and release our hold on it
        [items addObject:entry];
        
    }
}

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
    
    // If the element that ended was the channel, give up control to who gave us control in the first place
    if ([elementName isEqual:@"channel"])
    {
        [parser setDelegate:parentParserDelegate];
        [self trimItemTitles];
    }
}

- (void)trimItemTitles
{
    // Create a regular expression with the pattern: Author
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@".* :: (.*) :: .*" options:0 error:nil];
    
    // Loop through every title of the items in channel
    for (RSSItem *i in items) {
        NSString *itemTitle = [i title];
        
        // Find matches in the title string. The range argument specifies how much of the
        // title to search; in this case, all of it.
        NSArray *matches = [regex matchesInString:itemTitle options:0 range:NSMakeRange(0, [itemTitle length])];
        
        // If there was a match
        if ([matches count] > 0)
        {
            // Print the location of the match in the string and the string itself
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            NSRange r = [result range];
            NSLog(@"Match at {%d, %d} for %@!", r.location, r.length, itemTitle);
            
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


@end
