//
//  HeavyViewController.m
//  Created by aash on 2013-03-10.


#import "HeavyViewController.h"

// Constants
const float DISTANCE_TO_EDGE = 41.5;


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

// Michael suggests erasing this method (says it's from the template)
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// Michael suggests erasing this method (says it's from the template)
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration
{
    CGRect viewBounds = [[self view] bounds];
    
    UIViewAutoresizing leftStrutOnly = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UIViewAutoresizing rightStrutOnly = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        // Button on the right
        float yCenter = [shiftingButton center].y;
        float xCenter = [shiftingButton center].x;
        xCenter = viewBounds.size.width - DISTANCE_TO_EDGE;
        [shiftingButton setAutoresizingMask:rightStrutOnly];
        [shiftingButton setCenter:CGPointMake(xCenter, yCenter)];
    }
    else if(UIInterfaceOrientationIsPortrait(orientation)) {
        // Button on the left
        float yCenter = [shiftingButton center].y;
        float xCenter = [shiftingButton center].x;
        xCenter = DISTANCE_TO_EDGE;
        [shiftingButton setAutoresizingMask:leftStrutOnly];
        [shiftingButton setCenter:CGPointMake(xCenter, yCenter)];
    }
    else {
        NSLog(@"Error: Unexpected orientation encountered");
    }
    
    // Switch autoresizing strut from left-side to right-side of the shiftingButton
//    [shiftingButton autoresizingMask]
}

@end
