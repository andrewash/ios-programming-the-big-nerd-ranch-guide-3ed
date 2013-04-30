//
//  RSSItem.m
//  Created by aash on 2013-04-25.


#import "RSSItem.h"

//----------------------------------------------------------------------------------------------------------------------------------------------
// Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
// FYI: Extensive changes were made to this file for this challenge, especially:
//   - new threadID, postID properties
//   - populating those properties from RSS XML's <GUID> element
@implementation RSSItem
@synthesize title, link, parentParserDelegate, threadID, postID;

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    WSLog(@"\t\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    }
    else if ([elementName isEqual:@"link"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setLink:currentString];
    }
    else if ([elementName isEqual:@"guid"]) // Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
    {
        currentString = [[NSMutableString alloc] init];
    }

}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)str
{
    [currentString appendString:str];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"guid"]) //Assume GUID is the last element within an <item>, before the </item>
    {
        [self parseIDsFromCurrentStringURL];
        [parser setDelegate:parentParserDelegate];
    }
    currentString = nil;
}

- (void)parseIDsFromCurrentStringURL
{
//    NSLog(@"Parsing URL %@", currentString);
    // example URL: http://forums.bignerdranch.com/viewtopic.php?f=400&t=6278&p=17192#p17192
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"http:\\/\\/forums\\.bignerdranch\\.com/viewtopic\\.php\\?f=.*&t=(\\d+)&p=(\\d+)" options:0 error:nil];
    
    // Find matches in the title string. The range argument specifies how much of the
    // title to search; in this case, all of it.
    NSArray *matches = [regex matchesInString:currentString options:0 range:NSMakeRange(0, [currentString length])];
    
    // assertion: <guid>...</guid> contains one, and only one, URL matching our pre-configured RegEx
    if ([matches count] == 1)
    {
        // Print the location of the match in the string and the string itself
        NSTextCheckingResult *result = [matches objectAtIndex:0];
        
        // Two capture groups, so three ranges, let's verify
        if ([result numberOfRanges] == 3)
        {
            // Pull out the second range, which is the threadID
            NSRange tRange = [result rangeAtIndex:1];
            [self setThreadID:[[currentString substringWithRange:tRange] integerValue]];

            // Pull out the third range, which is the postID
            NSRange pRange = [result rangeAtIndex:2];
            [self setPostID:[[currentString substringWithRange:pRange] integerValue]];
            
            WSLog(@"Parsed threadID=%d and postID=%d", [self threadID], [self postID]);
        } else {
            NSLog(@"warning: Format of <GUID> element in RSS Feed XML appears to have changed from spec. The expected t= and p= query-string parameters do not appear to be present in this URL.");
        }
    } else {
        NSLog(@"warning: Format of <GUID> element in RSS Feed XML appears to have changed from spec. It appears to contain something other than 1 URL of the required format.");
    }

}
//================================================================================================================================================

@end
