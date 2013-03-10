//
//  HeavyViewController.m
//  Created by aash on 2013-03-10.


#import "HeavyViewController.h"

@interface HeavyViewController ()

@end

@implementation HeavyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)x
{
    // Return YES if incoming orientation is Portrait
    //  or either of the Landscapes, otherwise return NO
    return UIInterfaceOrientationIsPortrait(x) || UIInterfaceOrientationIsLandscape(x);
}

@end
