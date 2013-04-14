//  DetailViewController.m
//  Created by aash on 2013-04-14.


#import "DetailViewController.h"

// fix for iPhone 5+
// source http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DetailViewController loaded its view.");
    
    // FYI - background image obtained for non-commercial purposes
    // source: http://3.bp.blogspot.com/-wVbOcUcUP58/UFHQBu3BneI/AAAAAAAAKt4/HG1mY0qcpPM/s1600/artistic-abstract-95.jpg
    UIImageView *backgroundImage = [[UIImageView alloc]
                                    initWithImage:[UIImage imageNamed:iPhone568ImageNamed(@"wallpaper.jpg")]];

    // HOWTO: Set an image background (http://stackoverflow.com/a/2393920/1660322)
    [[self view] addSubview:backgroundImage];
    [[self view] sendSubviewToBack:backgroundImage];
}

@end
