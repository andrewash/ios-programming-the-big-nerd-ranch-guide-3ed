//
//  HypnosisterAppDelegate.m
//  Hypnosister
//
//  Created by aash on 2013-02-25.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import "HypnosisterAppDelegate.h"
#import "HypnosisView.h"

@implementation HypnosisterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//==HypnosisView should have a UIScrollView as its parent, rather than the window itself
    CGRect screenRect = [[self window] bounds];
    
    // Create the UIScrollView whose size (i.e. "frame size") matches that of the window
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:5.0];
    
    // You will get a warning here, ignore it for now
    [scrollView setDelegate:self];
    
    [[self window] addSubview:scrollView];
    
    // Create a HypnosisView instance, where:
    //  - dimensions are equal to size of the window (screenRect)
    view = [[HypnosisView alloc] initWithFrame:screenRect];
    
    // Add the view as a subview of the scrollView, instead of the window
    [scrollView addSubview:view];
    
    // Tell the scrollView how big its virtual world is
    CGRect bigRect = screenRect;
    [scrollView setContentSize:bigRect.size];
    
    BOOL success = [view becomeFirstResponder];
    if (success) {
        NSLog(@"HypnosisView became the first responder.");
    } else {
        NSLog(@"Could not become first responder.");
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return view;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
