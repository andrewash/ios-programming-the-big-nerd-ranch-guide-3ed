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
@end
