//
//  WebViewController.m
//  Created by aash on 2013-04-25.


#import "WebViewController.h"
#import "RSSItem.h"

@implementation WebViewController
- (void)loadView
{
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    
    // Tell web view to scale web content to fit within bounds of webview
    [wv setScalesPageToFit:YES];
    
    [self setView:wv];
}

- (UIWebView *)webView
{
    return (UIWebView *)[self view];        // uses a C-style "cast"
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

- (void)listViewController:(ListViewController *)lvc
              handleObject:(id)object
{
    // Cast the passed object to RSSItem
    RSSItem *entry = object;
    
    // Make sure that we are really getting a RSSItem
    if (![entry isKindOfClass:[RSSItem class]])
        return;
    
    // Grab the info from the item and push it into the appropriate views
    
    //   construct a URL with the link string of the item
    NSURL *url = [NSURL URLWithString:[entry link]];
    
    //   construct a request object with that URL
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //   load the request into the web view
    [[self webView] loadRequest:req];
    
    // Set the title of the web view controller's navigation item
    [[self navigationItem] setTitle:[entry title]];
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
    if (barButtonItem == [[self navigationItem] leftBarButtonItem])
        [[self navigationItem] setLeftBarButtonItem:nil];
}
@end
