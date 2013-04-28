//
//  WebViewController.m
//  Created by aash on 2013-04-25.


#import "WebViewController.h"

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
@end
