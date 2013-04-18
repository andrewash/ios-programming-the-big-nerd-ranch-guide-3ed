//
//  HypnosisViewController.m
//  Created by aash on 2013-03-03.


#import "HypnosisViewController.h"
#import "HypnosisView.h"

@implementation HypnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the superclass' designated initializer
    self = [super initWithNibName:nil
                           bundle:nil];
    if(self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Hypnosis"];

        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices (by convention)
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that image on the tab bar item
        [tbi setImage:i];
    }
    return self;
}                   

- (void)loadView
{
    // Create a view
    CGRect frame = [[UIScreen mainScreen] bounds];
    HypnosisView *v = [[HypnosisView alloc] initWithFrame:frame];
    
    // Set it as *the* view of this view controller
    [self setView:v];       // sets "the view that this controller manages" (powerful!)
}

- (void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    NSLog(@"HypnosisViewController loaded its view.");
    
    //-------------------------------------------------------------------------------
    // Assignment #2, Q4 - Ch. 7, silver challenge
    NSArray *colourChoices = [[NSArray alloc] initWithObjects: @"Red", @"Green", @"Blue", nil];
    // Create an automatically sized UISegmentedControl based off a set of choices in an array
    UISegmentedControl *colourChooser = [[UISegmentedControl alloc] initWithItems: colourChoices];

    CGRect bounds = [[self view] bounds];
    CGSize ccSize = [colourChooser bounds].size;
    float xOffset = (bounds.size.width - ccSize.width) / 2.0;
    float yOffset = (bounds.size.height - ccSize.height) * 0.75;
    [colourChooser setFrame: CGRectMake(xOffset, yOffset, ccSize.width, ccSize.height)];
    [[self view] addSubview:colourChooser];
    
    [colourChooser addTarget:self
                      action:@selector(colourChooserValueChanged:)
            forControlEvents:UIControlEventValueChanged];
    //===============================================================================
}

//-------------------------------------------------------------------------------
// Assignment #2, Q4 - Ch. 7, silver challenge
// - respond to the colourChooser's "UIControlEventValueChanged" event
- (void)colourChooserValueChanged:(id)sender
{
    UISegmentedControl *cc = (UISegmentedControl *)sender;
    HypnosisView *v = (HypnosisView *) [self view];
    switch([cc selectedSegmentIndex])
    {
        case 0:
            [v setCircleColour: [UIColor redColor]];
            break;
        case 1:
            [v setCircleColour: [UIColor greenColor]];
            break;
        case 2:
            [v setCircleColour: [UIColor blueColor]];
            break;
        case UISegmentedControlNoSegment:
            NSLog(@"error: colourChooser says no segment is currently selected. This should not be possible.");
            break;
        default:
            NSLog (@"error: [colourChooser selectedSegmentIndex] is out of range");
            break;
    }    
}
//===============================================================================
@end
