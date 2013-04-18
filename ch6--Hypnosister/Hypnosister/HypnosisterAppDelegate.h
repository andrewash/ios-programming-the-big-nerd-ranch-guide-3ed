//
//  HypnosisterAppDelegate.h
//  Hypnosister
//
//  Created by aash on 2013-02-25.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HypnosisView.h"    // we're adding an instance variable of type HypnosisView, to this class.

@interface HypnosisterAppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>
{
    HypnosisView *view;
}
@property (strong, nonatomic) UIWindow *window;

@end
