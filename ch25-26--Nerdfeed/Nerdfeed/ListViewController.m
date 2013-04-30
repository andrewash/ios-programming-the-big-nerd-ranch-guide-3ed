//
//  ListViewController.m
//  Created by aash on 2013-04-22.


#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"

@implementation ListViewController
@synthesize webViewController;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(showInfo:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        // Kick off the NSURLConnection whenever the ListViewController is created
        [self fetchEntries];
    }
    
    NSLog(@"ListViewController initialized");
    return self;
}

// shouldAutorotateToInterfaceOrientation:
//   Deprecated in iOS 6.0. Override the supportedInterfaceOrientations and
//   preferredInterfaceOrientationForPresentation methods instead.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

// When "Info" button is tapped, the detail view controller (in split view) will be replaced with an
//   instance of ChannelViewController
- (void)showInfo:(id)sender
{
    // Create the channel view controller
    ChannelViewController *channelViewController = [[ChannelViewController alloc]
                                                    initWithStyle:UITableViewStyleGrouped];
    
    if ([self splitViewController])
    {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:channelViewController];
        
        // Create an array with our nav controller and this new VC's nav controller
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nvc, nil];
        
        // Grab a pointer to the split view controller and reset its view controllers array.
        [[self splitViewController] setViewControllers:vcs];
        
        // Make detail view controller the delegate of the split view controller
        // - ignore this warning
        [[self splitViewController] setDelegate:channelViewController];
        
        // If a row has been selected, deselect it so that a row is not selected when viewing the info
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        if (selectedRow)
             [[self tableView] deselectRowAtIndexPath:selectedRow
                                             animated:YES];
        
        //----------------------------------------------------------------------------------------------------------------------------------------------
        // Final Exam, Q1 (Ch. 26, Silver Challenge: Swapping the Master Button)
        if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
        {
            UIBarButtonItem *showListView = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:[self splitViewController] action:@selector(toggleMasterVisible:)];
            [[channelViewController navigationItem] setLeftBarButtonItem:showListView];
        }
        else {
            [[channelViewController navigationItem] setLeftBarButtonItem:nil];
        }
        //==============================================================================================================================================

    } else {  // for iPhones, iPod Touches (non-iPad devices)
        
        [[self navigationController] pushViewController:channelViewController
                                               animated:YES];
    }
    
    // Give the VC the channel object through the protocol message
    [channelViewController listViewController:self
                                 handleObject:channel];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[channel threadsOfItems] count];
}

//----------------------------------------------------------------------------------------------------------------------------------------------
// Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
//   iOS SDK: If the cell is enabled and the accessory type is UITableViewCellAccessoryDetailDisclosureButton,
//            the accessory view tracks touches and, when tapped, sends the data-source object a tableView:accessoryButtonTappedForRowWithIndexPath: message.
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Show all child posts when the disclosure indicator is tapped on the parent post (example of this design: see "Sounds" within the iOS Settings)
    // - technical details: Create an instance of ListViewController, within our ListViewController, to "navigate a data-hierarchy using table views"
    // - see http://www.iphonesdkarticles.com/2009/03/uitableview-drill-down-table-view.html
    // - see http://goo.gl/Bn7nF
    NSMutableArray *thread = [[channel threadsOfItems] objectAtIndex:[indexPath row]];
  
    NSLog(@"Parent item of the thread at row %d has been selected. Here are its children:", [indexPath row]);
    for (RSSItem *item in thread) {
        if ([thread indexOfObject:item] > 0)
        {
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@".* :: .* :: (.*)" options:0 error:nil];
            NSArray *matches = [regex matchesInString:[item title] options:0 range:NSMakeRange(0, [[item title] length])];
            // If there was a match
            if ([matches count] == 1) {
                NSTextCheckingResult *result = [matches objectAtIndex:0];
                // One capture group, so two ranges, let's verify
                if ([result numberOfRanges] == 2)
                {
                    // Pull out the second range, which will be the capture group
                    NSRange r = [result rangeAtIndex:1];
                    
                    // Set the title of the item to the string within the capture group
                    NSLog(@"\t%@", [[item title] substringWithRange:r]);
                }
            }
        }
    }
    // TODO: Remove this alert once the above TODO's have been implemented.
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops! You've reached the edge of this app's known world"
                                                 message:@"Please check your NSLog output. The children of the item whose disclosure accessory you tapped are shown in the log."
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil]; // aa: cool! this is the first alert I've written
    [av show];
}
//================================================================================================================================================

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    //----------------------------------------------------------------------------------------------------------------------------------------------
    // Final Exam, Q3 (Ch. 26, Gold Challenge: Showing Threads)
    NSMutableArray *thread = [[channel threadsOfItems] objectAtIndex:[indexPath row]];
    RSSItem *mostRecentItemInThread = [thread objectAtIndex:0];
    [[cell textLabel] setText:[mostRecentItemInThread title]];
    
    // this cell gets a "disclosure" accessory IIF there is more than one post in this thread
    if ([thread count] > 1)
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    //================================================================================================================================================
    
    return cell;
}

// Show the selected RSS item's linked article in an embedded web browser (UIWebView)
// details: Pushes the web view controller onto the navigation stack - this implicitly
//          creates the web view controller's view the first time through
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if this view controller (ListViewController) is part of a SplitViewController
    // If ListViewController is in a split view controller, we leave it to the UISplitViewController to place WebViewController on the screen (which it does, because it's in the svc's array of view controllers)
    if (![self splitViewController])
    {
        [[self navigationController] pushViewController:webViewController
                                               animated:YES];
    } else {
        // We have to create a new navigation controller, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
        
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        
        [[self splitViewController] setViewControllers:vcs];
        
        // Make the detail view controller the delegate of the split view controller
        // - ignore this warning
        [[self splitViewController] setDelegate:webViewController];
    }
    
    // Grab the selected item
    NSMutableArray *thread = [[channel threadsOfItems] objectAtIndex:[indexPath row]];
    RSSItem *entry = [thread objectAtIndex:0];
    
    [webViewController listViewController:self handleObject:entry];
}

- (void)fetchEntries {
    // Create a new data container for the stuff that comes back from the service
    xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want -
    // note we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=7_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
        // FYI - discovered that this web service accepts query parameter "limit=(1_DAY|7_DAY)"
    
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
    WSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict {
    WSLog(@"%@ found a %@ element", self, elementName);
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
