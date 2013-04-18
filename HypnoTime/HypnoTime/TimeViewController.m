//
//  TimeViewController.m
//  HypnoTime
//  Created by aash on 2013-03-03.


#import "TimeViewController.h"

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Get a pointer to the application bundle object
    NSBundle *appBundle = [NSBundle mainBundle];
    
    self = [super initWithNibName:@"TimeViewController"
                           bundle:appBundle];
    
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Time"];
        
        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices (by convention)
        UIImage *i = [UIImage imageNamed:@"Time.png"];

        // Put that image on the tab bar item
        [tbi setImage:i];
    }
    return self;
}

- (IBAction)showCurrentTime:(id)sender
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    [timeLabel setText:[formatter stringFromDate:now]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor greenColor]];
    
    NSLog(@"TimeViewController loaded its view.");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will appear");
    [super viewWillAppear:animated];
    [self showCurrentTime:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will DISappear");
    [super viewWillDisappear:animated];
}

@end
