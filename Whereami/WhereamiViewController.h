//
//  WhereamiViewController.h
//  Andrew Ash

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *locationTitleField;

    //------------------------------------------------------------------------------------
    // Assignment #2, Q2 (Ch. 5, Silver Challenge)
    //  has segments called "Standard", "Satellite" (selected in viewDidLoad:), and "Hybrid"
    IBOutlet UISegmentedControl *typeSelector;
    //====================================================================================
}

- (void)typeSelectorValueChanged:(id)sender;
- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;

@end
