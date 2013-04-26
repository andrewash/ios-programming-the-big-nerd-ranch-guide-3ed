//
//  ListViewController.m
//  Created by aash on 2013-04-22.


#import "ListViewController.h"
#import "RSSChannel.h"

@implementation ListViewController
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        // Kick off the NSURLConnection whenever the ListViewController is created
        [self fetchEntries];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)fetchEntries {
    // Create a new data container for the stuff that comes back from the service
    xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want -
    // note we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    // For Apple's Hot News feed, replace the line above with
    // NSURL *url = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
    
    // Put that URL into an NSURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

// This method will be called several times as the data arrives
//  "the only way for an asynchronous delegate to retrieve the loaded data"
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    // FYI - "NSData objects let simple allocated buffers (that is, _data with no embedded pointers_) take on the behavior of Foundation objects."
    [xmlData appendData:data];
}

// Parsing XML with NSXMLParser
- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // Give it a delegate - ignore the warning here for now
    [parser setDelegate:self];
    
    // Tell it to start parsing - the document will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent to it before this line finishes execution - it is blocking
    [parser parse];
    
    // Get rid of the XML data as we no longer need it
    xmlData = nil;
    
    // Get rid of the connection, no longer need it
    connection = nil;
    
    // Reload the table; for now, the table will be empty
    [[self tableView] reloadData];
    
    // DEBUG: Check our work in RSSChannel.m
    NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict {
    NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"channel"])
    {
        // If the parser saw a channel, create new instance, store in our ivar
        channel = [[RSSChannel alloc] init];
        
        // Give the channel object a pointer back to ourselves for later
        [channel setParentParserDelegate:self];
        
        // Set the parser's delegate to teh channel object
        // There will be a warning here, ignore it for now
        [parser setDelegate:channel];
    }
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    // Release the connection object, we're done with it
    connection = nil;
    
    // Release the xmlData object, we're done with it
    xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil]; // aa: cool! this is the first alert I've written
    [av show];
}

@end
