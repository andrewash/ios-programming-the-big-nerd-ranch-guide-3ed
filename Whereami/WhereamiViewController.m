//
//  WhereamiViewController.m
//  Andrew Ash

#import "WhereamiViewController.h"

@interface WhereamiViewController ()

@end

@implementation WhereamiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        [locationManager setDelegate:self];  // ignore this warning
        
        // And we want it to be as accurate as possible
        //  regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //------------------------------------------------------------------------------------
        // Assignment #1, Q3 (Ch. 4, Bronze Challenge)
        [locationManager setDistanceFilter:50.0];
        //====================================================================================
        
        // Tell our manager to start looking for its location immediately
        [locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    //   FYI - needed b/c delegate is __unsafe_unretained, so ARC doesn't apply
    [locationManager setDelegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);

    //------------------------------------------------------------------------------------
    // Assignment #1, Q4 (Ch. 4, Silver Challenge)
    // FYI - from docs:
    //   "Implementation of this method is optional but expected if you start heading updates using
    //     the startUpdatingHeading method."
    //   "The location manager object calls this method after you initially start the heading service.
    //     Subsequent events are delivered when the previously reported value changes by more than the
    //     value specified in the headingFilter property of the location manager object.")
    if([CLLocationManager headingAvailable]) // note: docs say to use the headingAvailable class method, instead of the instance method.
    {
        [locationManager startUpdatingHeading];
        NSLog(@"debug: heading information is available");
    }
    else
    {
        NSLog(@"warning: heading information not available for this device");
    }
    //====================================================================================

}

- (void)locationManager:(CLLocationManager *)manager
    didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

//------------------------------------------------------------------------------------
// Assignment #1, Q4 (Ch. 4, Silver Challenge)
- (void)locationManager:(CLLocationManager *)manager
    didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"%@", newHeading);
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return true;
}
//====================================================================================

// - (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
//     --- vs. ---
// - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
// Theory => the first method *could have been* declared as
// - (BOOL)locationManager:(CLLocationManager *)manager shouldDisplayHeadingCalibration


@end
