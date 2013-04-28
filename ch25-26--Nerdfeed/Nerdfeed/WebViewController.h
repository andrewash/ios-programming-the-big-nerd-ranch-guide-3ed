//
//  WebViewController.h
//  Created by aash on 2013-04-25.


#import <Foundation/Foundation.h>
#include "ListViewController.h"

@interface WebViewController : UIViewController <ListViewControllerDelegate>

@property (nonatomic, readonly) UIWebView *webView;
@end
