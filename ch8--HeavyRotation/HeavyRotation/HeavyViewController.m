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

//------------------------------------------------------------------------------------
// Assignment #2, Q5 (Ch. 8, Gold Challenge)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)x
{
    // Return YES if incoming orientation is Portrait
    //  or either of the Landscapes, otherwise return NO
    return UIInterfaceOrientationIsPortrait(x) || UIInterfaceOrientationIsLandscape(x);
}


//------------------------------------------------------------------------------------
// Assignment #2, Q5 (Ch. 8, Gold Challenge)
// When app starts in landscape, correct the view
// - this method adapted from http://goo.gl/HNyXw
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear event triggered!");
    [super viewWillAppear:animated];
    [self updateLayoutForNewOrientation:[self interfaceOrientation]];
}


//------------------------------------------------------------------------------------
// Assignment #2, Q5 (Ch. 8, Gold Challenge)
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration
{
    [self updateLayoutForNewOrientation:orientation];
}

//------------------------------------------------------------------------------------
// Assignment #2, Q5 (Ch. 8, Gold Challenge)
// the idea of generalizing this code into its own function comes from http://goo.gl/HNyXw
- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation
{
    CGRect viewBounds = [[self view] bounds];
    
    UIViewAutoresizing leftStrutOnly = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UIViewAutoresizing rightStrutOnly = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        // Image on the left
        float xOrigin = [shiftingButton frame].origin.x;
        float yOrigin = [shiftingImage frame].origin.y;
        [shiftingImage setFrame:CGRectMake(xOrigin, yOrigin, [shiftingImage frame].size.width, [shiftingImage frame].size.height)];

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
        
        // Image on the right (image's origin is as far as the button is from the edge, plus half a button's width)
        float marginSize = DISTANCE_TO_EDGE - ([shiftingButton frame].size.width * 0.5);
        float xOrigin = marginSize + [shiftingButton frame].size.width + marginSize;
        float yOrigin = [shiftingImage frame].origin.y;
        [shiftingImage setFrame:CGRectMake(xOrigin, yOrigin, [shiftingImage frame].size.width, [shiftingImage frame].size.height)];
    }
    else {
        NSLog(@"Error: Unexpected orientation encountered");
    }
}
@end
