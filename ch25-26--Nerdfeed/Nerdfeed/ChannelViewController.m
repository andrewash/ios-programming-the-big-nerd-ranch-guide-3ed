//
//  ChannelViewController.m
//  Created by aash on 2013-04-28.


#import "ChannelViewController.h"
#import "RSSChannel.h"

@implementation ChannelViewController

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:@"UITableViewCell"];
    
    if ([indexPath row] == 0)
    {
        // Put the title of the channel in row 0
        [[cell textLabel] setText:@"Title"];
        [[cell detailTextLabel] setText:[channel title]];
    } else {
        // Put the description of the channel in row 1
        [[cell textLabel] setText:@"Info"];
        [[cell detailTextLabel] setText:[channel infoString]];
    }
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)listViewController:(ListViewController *)lvc
              handleObject:(id)object
{
    // Make sure the ListViewController gave us the right object
    if (![object isKindOfClass:[RSSChannel class]])
        return;
    
    channel = object;
    
    [[self tableView] reloadData];
}

// When ListViewController becomes hidden, show a 'List' button in navbar, so users can see it
// TODO: can I refactor to remove duplicate code? see WebViewController & ChannelViewcontroller
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    // If this bar button item doesn't have a title, it won't appear at all.
    [barButtonItem setTitle:@"List"];
    
    // Take this bar button item and put it on the left side of our nav item.
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

// When ListViewController becomes visible, remove/hide the 'List' button
// TODO: can I refactor to remove duplicate code? see WebViewController & ChannelViewcontroller
- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // double-check that it's the correct button, even through we know it is
    if ([barButtonItem action] == @selector(toggleMasterVisible:))  // fix for Final Exam, Q1 (Ch. 26, Silver Challenge: Swapping the Master Button)
        [[self navigationItem] setLeftBarButtonItem:nil];
}
@end
